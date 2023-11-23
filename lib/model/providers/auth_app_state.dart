import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum ApplicationLoginState {
  loggedIn,
  loggedOut,
  signIn,
  register,
  forgotPassword,
}

class AuthAppState extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AuthAppState() {
    init();
  }

  Future<void> init() async {
    _auth.userChanges().listen((user) async {
      print('user update!');
      if (user != null) {
        print('user : ${user.email}');

        _loginState = ApplicationLoginState.loggedIn;
        _currentUser = user;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      print('loginstate : $_loginState');

      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;
  User? _currentUser = FirebaseAuth.instance.currentUser;
  User? get currentUser => _currentUser;

  void startSignInFlow() {
    _loginState = ApplicationLoginState.signIn;
    notifyListeners();
  }

  void startRegisterFlow() {
    _loginState = ApplicationLoginState.register;
    notifyListeners();
  }

  String convertErrorcodeToMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Bruger ikke fundet med den e-mail.';
      case 'wrong-password':
        return 'Forkert password.';
      case 'network-request-failed':
        return 'Kunne ikke forbinde til internettet. Prøv igen.';
      case 'too-many-requests':
        return 'Du har skrevet din kode forkert for mange gange. Prøv igen senere.';
      case 'weak-password':
        return 'Password er for svag.';
      case 'email-already-in-use':
        return 'En bruger men den e-mail existerer allerede.';
      case 'invalid-email':
        return 'E-mail er ugyldig.';
      case 'user-mismatch':
        return 'Forkert login oplysninger.';
      case 'invalid-credential':
        return 'Kunne ikke verificere login.';
      default:
        return code;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      successCallback();
      // await _analytics.logLogin(loginMethod: 'signInWithEmailAndPassword');
      return cred;
    } on FirebaseAuthException catch (e) {
      errorCallback(convertErrorcodeToMessage(e.code));
    } catch (e) {
      errorCallback('Der skete en fejl. Prøv igen.');
    }

    return null;
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.signIn;
    notifyListeners();
  }

  // Future<bool> registerAccount(String email, String password, String companyName, String contactName, String contactPhone,
  //     void Function() successCallback, void Function(String message) errorCallback) async {
  //   try {
  //     var userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     successCallback();
  //     var currentdate = DateTime.now();
  //     await _firestore.collection(DbCollection.unApprovedUsers.name).doc(userCred.user?.uid).set({
  //       'uid': userCred.user?.uid,
  //       'contactEmail': email,
  //       'companyName': companyName,
  //       'contactName': contactName,
  //       'contactPhone': contactPhone,
  //       'startDate': currentdate.millisecondsSinceEpoch,
  //     });
  //     userCred.user!.sendEmailVerification();
  //     await _analytics.logSignUp(signUpMethod: 'createUserWithEmailAndPassword');

  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     errorCallback(convertErrorcodeToMessage(e.code));
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen.');
  //   }
  //   return false;
  // }

  // Future<bool> sendVerifyEmail(void Function(String message) errorCallback) async {
  //   try {
  //     await _currentUser!.sendEmailVerification();
  //     await currentUser!.reload();
  //     return true;
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen.');
  //   }
  //   return false;
  // }

  // Future<bool> reloadUser(void Function(String message) errorCallback) async {
  //   try {
  //     await currentUser!.reload();
  //     await Future.delayed(const Duration(seconds: 1));
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen.');
  //   }
  //   return false;
  // }

  Future<bool> signOut(void Function(String message) errorCallback) async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      errorCallback('Der skete en fejl. Prøv igen.');
    }
    return false;
  }

  Future<bool> resetUserPassword(String email, void Function() successCallback, void Function(String message) errorCallback) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      successCallback();
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(convertErrorcodeToMessage(e.code));
    } catch (e) {
      errorCallback('Der skete en fejl. Prøv igen senere.');
    }
    return false;
  }

  // Future<bool> deleteUser(BuildContext context, void Function(String message) errorCallback,
  //     Future<String?> Function(String title) requireLoginCallback, bool isApproved) async {
  //   try {
  //     String userPath = isApproved ? DbCollection.users.name : DbCollection.unApprovedUsers.name;
  //     String? result = await requireLoginCallback('Slet Profil');
  //     // String? result = await reauthenticateDialog(context, 'Slet Profil', errorCallback);

  //     if (result != null) {
  //       if (result == 'Success') {
  //         await _firestore.collection(userPath).doc(currentUser!.uid).delete();
  //         await currentUser!.delete();
  //         return true;
  //       } else {
  //         errorCallback(result);
  //       }
  //     } else {
  //       errorCallback('Handling blev annulleret.');
  //     }

  //     // return true;
  //   } on FirebaseAuthException catch (e) {
  //     errorCallback(convertErrorcodeToMessage(e.code));
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen.');
  //   }
  //   return false;
  // }

  // Future<bool> updateUserEmail(BuildContext context, String uid, String email, void Function(String message) errorCallback,
  //     Future<String?> Function(String title) requireLoginCallback, bool isApproved) async {
  //   String userPath = isApproved ? DbCollection.users.name : DbCollection.unApprovedUsers.name;
  //   try {
  //     await currentUser!.updateEmail(email);
  //     await _firestore.collection(userPath).doc(uid).update({
  //       'contactEmail': email,
  //     });

  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'requires-recent-login') {
  //       try {
  //         String? result = await requireLoginCallback('Skift E-mail');
  //         // String? result = await reauthenticateDialog(context, 'Skift E-mail', errorCallback);
  //         if (result != null) {
  //           await currentUser!.updateEmail(email);
  //           await _firestore.collection(userPath).doc(uid).update({
  //             'contactEmail': email,
  //           });
  //           return true;
  //         } else {
  //           errorCallback('Handling blev annulleret.');
  //         }
  //       } catch (e) {
  //         errorCallback('Der skete en fejl. Prøv igen.');
  //       }
  //     } else {
  //       errorCallback(convertErrorcodeToMessage(e.code));
  //     }
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen.');
  //   }
  //   return false;
  // }

  // Future<bool> changeUserPassword(String currentPassword, String newPassword, void Function(String message) errorCallback) async {
  //   try {
  //     var authCredential = EmailAuthProvider.credential(email: currentUser!.email ?? '', password: currentPassword);
  //     var result = await reauthenticateUser(authCredential);
  //     if (result == null) {
  //       await currentUser!.updatePassword(newPassword);
  //       return true;
  //     } else {
  //       errorCallback(result);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     errorCallback(convertErrorcodeToMessage(e.code));
  //   } catch (e) {
  //     errorCallback('Der skete en fejl. Prøv igen senere.');
  //   }
  //   return false;
  // }

  // Future<String?> reauthenticateUser(AuthCredential authCredential) async {
  //   try {
  //     await currentUser!.reauthenticateWithCredential(authCredential);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return convertErrorcodeToMessage(e.code);
  //   } catch (e) {
  //     return 'Der skete en fejl. Prøv igen.';
  //   }
  // }

  ///
  /// Changes a FirebaseAuth users password by their uid, and returns the password as a String.
  ///
}
