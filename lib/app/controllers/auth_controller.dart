import 'package:chattie/app/data/models/users_model.dart';
import 'package:chattie/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final box = GetStorage();

  GoogleSignInAccount? _currentUser;
  UserCredential? _userCredential;
  final user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String skipIntro = 'skipIntro';

  Future<void> firstInitialize() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntroFunction().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        CollectionReference userCollection = firestore.collection('users');
        var checkUser = await userCollection.doc(_currentUser?.email).get();

        var getUserData = checkUser.data() as Map<String, dynamic>;

        await userCollection.doc(_currentUser?.email).update({
          "lastSignInTime":
              _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });
        user(UsersModel.fromJson(getUserData));
        user.refresh();

        var dataChat = await userCollection
            .doc(_currentUser?.email)
            .collection('chats')
            .get();

        if (dataChat.docs.isNotEmpty) {
          List<ChatInUser> chatsInUser = List.empty();
          for (var element in dataChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            chatsInUser.add(ChatInUser(
              chatId: dataDocChatId,
              connection: dataDocChat['connection'],
              lastTime: dataDocChat['lastTime'],
              totalUnread: dataDocChat['totalUnread'],
            ));
          }

          user.update((val) {
            val!.chats = chatsInUser;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  Future<bool> skipIntroFunction() async {
    try {
      if (box.read(skipIntro) != null || box.read(skipIntro) == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  Future<void> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('CREDENTIAL : $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        debugPrint('Berhasil Login');
        debugPrint('$_currentUser');

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        debugPrint('User Credential');
        debugPrint('$_userCredential');

        // SAVE LOCAL STORAGE
        if (box.read(skipIntro) != null) {
          box.remove(skipIntro);
        }
        box.write(skipIntro, true);

        await createUserToFirestore().then((value) {
          if (value) {
            isAuth.value = true;
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.snackbar('Error', 'Gagal Input Data');
          }
        });
      } else {
        Get.snackbar('Error', 'Gagal Login');
      }
    } catch (error, stack) {
      debugPrint('login Error $error');
      debugPrint('login Error Stack $stack');
    }
  }

  Future<bool> createUserToFirestore() async {
    try {
      // INSERT DATA TO FIRESTORE
      CollectionReference userCollection = firestore.collection('users');
      var checkUser = await userCollection.doc(_currentUser?.email).get();

      if (checkUser.exists) {
        await userCollection.doc(_currentUser?.email).update({
          "lastSignInTime":
              _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        user(UsersModel.fromJson(checkUser.data() as Map<String, dynamic>));
      } else {
        await userCollection.doc(_currentUser?.email).set({
          "uid": _userCredential?.user!.uid,
          "keyName": _currentUser?.displayName?.substring(0, 1).toUpperCase(),
          "name": _currentUser?.displayName,
          "email": _currentUser?.email,
          "photoUrl": _currentUser?.photoUrl,
          "status": "",
          "creationTime":
              _userCredential!.user!.metadata.creationTime!.toIso8601String(),
          "lastSignInTime":
              _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
          "updatedTime": DateTime.now().toIso8601String(),
        });

        userCollection.doc(_currentUser?.email).collection('chats');

        var dataUser = await userCollection.doc(_currentUser?.email).get();

        user(UsersModel.fromJson(dataUser.data() as Map<String, dynamic>));
        user.refresh();

        var dataChat = await userCollection
            .doc(_currentUser?.email)
            .collection('chats')
            .get();

        if (dataChat.docs.isNotEmpty) {
          List<ChatInUser> chatsInUser = List.empty();
          for (var element in dataChat.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            chatsInUser.add(ChatInUser(
              chatId: dataDocChatId,
              connection: dataDocChat['connection'],
              lastTime: dataDocChat['lastTime'],
              totalUnread: dataDocChat['totalUnread'],
            ));
          }

          user.update((val) {
            val!.chats = chatsInUser;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }
      }

      return true;
    } catch (error, stack) {
      debugPrint('createUserToFirestore Error :  $error');
      debugPrint('createUserToFirestore Error Stack :  $stack');
      return false;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> changeProfile({String? name, String? status}) async {
    try {
      CollectionReference userCollection = firestore.collection('users');
      var date = DateTime.now().toIso8601String();
      await userCollection.doc(_currentUser?.email).update({
        "name": name,
        "keyName": name?.substring(0, 1).toUpperCase(),
        "status": status,
        "lastSignInTime":
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": date,
      });

      user.update((val) {
        val!.name = name;
        val.keyName = name?.substring(0, 1).toUpperCase();
        val.status = status;
        val.lastSignInTime =
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val.updatedTime = date;
      });

      user.refresh();

      Get.defaultDialog(title: "Success", middleText: "Change profile success")
          .then((value) => Get.back());
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> changeStatus({String? status}) async {
    try {
      CollectionReference userCollection = firestore.collection('users');
      var date = DateTime.now().toIso8601String();
      await userCollection.doc(_currentUser?.email).update({
        "status": status,
        "lastSignInTime":
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": date,
      });

      user.update((val) {
        val!.status = status;
        val.lastSignInTime =
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val.updatedTime = date;
      });

      user.refresh();

      Get.defaultDialog(title: "Success", middleText: "Change Status success")
          .then((value) => Get.back());
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> addConnection({required String friendEmail}) async {
    try {
      var date = DateTime.now().toIso8601String();
      String? chatId;
      bool flagNewConnection = false;
      CollectionReference userCollection = firestore.collection('users');
      CollectionReference chatCollection = firestore.collection('chats');

      final docChats = await userCollection
          .doc(_currentUser?.email)
          .collection('chats')
          .get();

      if (docChats.docs.isNotEmpty) {
        final checkConnection = await userCollection
            .doc(_currentUser?.email)
            .collection('chats')
            .where('connection', isEqualTo: friendEmail)
            .get();
        if (checkConnection.docs.isNotEmpty) {
          flagNewConnection = false;
          chatId = checkConnection.docs[0].id;
        } else {
          flagNewConnection = true;
        }
      } else {
        flagNewConnection = true;
      }

      if (flagNewConnection) {
        final checkConnection =
            await chatCollection.where('connections', whereIn: [
          [
            _currentUser?.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser?.email,
          ],
        ]).get();

        if (checkConnection.docs.isNotEmpty) {
          chatId = checkConnection.docs[0].id;
          final chatData =
              checkConnection.docs[0].data() as Map<String, dynamic>;

          await userCollection
              .doc(_currentUser?.email)
              .collection('chats')
              .doc(chatId)
              .set({
            "connection": friendEmail,
            "lastTime": chatData['lastTime'],
            "totalUnread": 0,
          });

          var dataChat = await userCollection
              .doc(_currentUser?.email)
              .collection('chats')
              .get();

          if (dataChat.docs.isNotEmpty) {
            List<ChatInUser> chatsInUser = [];
            for (var element in dataChat.docs) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              chatsInUser.add(ChatInUser(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['totalUnread'],
              ));
            }

            user.update((val) {
              val!.chats = chatsInUser;
            });
          } else {
            user.update((val) {
              val!.chats = [];
            });
          }
        } else {
          final newChatDoc = await chatCollection.add({
            "connections": [
              _currentUser?.email,
              friendEmail,
            ]
          });

          chatCollection.doc(newChatDoc.id).collection('chat');

          await userCollection
              .doc(_currentUser?.email)
              .collection('chats')
              .doc(newChatDoc.id)
              .set({
            "connection": friendEmail,
            "lastTime": date,
            "totalUnread": 0,
          });

          var dataChat = await userCollection
              .doc(_currentUser?.email)
              .collection('chats')
              .get();

          if (dataChat.docs.isNotEmpty) {
            List<ChatInUser> chatsInUser = [];
            for (var element in dataChat.docs) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              chatsInUser.add(ChatInUser(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['totalUnread'],
              ));
            }

            user.update((val) {
              val!.chats = chatsInUser;
            });
          } else {
            user.update((val) {
              val!.chats = [];
            });
          }
          chatId = newChatDoc.id;
        }
      }

      debugPrint('CHAT ID :$chatId');
      user.refresh();

      final updateStatusChat = await chatCollection
          .doc(chatId)
          .collection('chat')
          .where('isRead', isEqualTo: false)
          .where('penerima', isEqualTo: _currentUser?.email)
          .get();

      for (var element in updateStatusChat.docs) {
        await chatCollection
            .doc(chatId)
            .collection('chat')
            .doc(element.id)
            .update({"isRead": true});
      }

      await userCollection
          .doc(_currentUser?.email)
          .collection('chats')
          .doc(chatId)
          .update({"totalUnread": 0});

      Get.toNamed(Routes.CHAT, arguments: {
        "chatId": chatId,
        "friendEmail": friendEmail,
      });
    } catch (e, stack) {
      debugPrint('addConnection Error : $e');
      debugPrint('addConnection Error stack: $stack');
    }
  }

  Future<void> changePhotoProfile({required String photoUrl}) async {
    try {
      CollectionReference userCollection = firestore.collection('users');
      var date = DateTime.now().toIso8601String();
      await userCollection.doc(_currentUser?.email).update({
        "photoUrl": photoUrl,
        "updatedTime": date,
      });

      user.update((val) {
        val!.photoUrl = photoUrl;
        val.updatedTime = date;
      });

      user.refresh();

      Get.defaultDialog(
              title: "Success", middleText: "Change Photo Profile success")
          .then((value) => Get.back());
    } catch (e) {
      debugPrint('Error $e');
      Get.defaultDialog(title: 'Error', middleText: '$e');
    }
  }
}
