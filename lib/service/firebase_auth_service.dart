import 'package:cityloveradmin/models/adminmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String errorMessage = '';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<AdminModel?> createEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      errorMessage = '';
      return userCredential.user != null
          ? AdminModel(
              userID: userCredential.user!.uid,
              userEmail: userCredential.user!.email!,
              status: true,
              role: 1)
          : null;
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'invalid-email':
          errorMessage = 'Lütfen geçerli bir email adresi giriniz.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email zaten başka bir hesap tarafından kullanılıyor.';
          break;
        case 'weak-password':
          errorMessage = 'Lütfen daha güçlü bir parola giriniz.';
          break;
        default:
          errorMessage = 'Hata: ${ex.code}';
          debugPrint(ex.code);
      }
      return null;
    }
  }

  AdminModel? userToUserModel(User? user) {
    if (user != null) {
      return AdminModel(
        userID: user.uid,
        userEmail: user.email ?? '',
      );
    } else {
      return null;
    }
  }

  Future<AdminModel?> currentUser() async {
    try {
      var user = firebaseAuth.currentUser;
      return userToUserModel(user);
    } catch (e) {
      debugPrint("CurrentUser Hatası: ${e.toString()}");
      return null;
    }
  }

  Future<AdminModel?> signInEmailPassword(String email, String sifre) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: sifre);
      errorMessage = '';
      return userToUserModel(userCredential.user);
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'invalid-email':
          errorMessage = 'Lütfen geçerli bir email adresi giriniz';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email zaten başka bir hesap tarafından kullanılıyor.';
          break;
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Lütfen parolanızı kontrol ediniz.';
          break;

        default:
      }
      return null;
    }
  }

  Future<bool?> signOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("Singout Hatası: ${e.toString()}");
      return null;
    }
  }

  // Future<bool?> updatePassword(String newPassword) async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  //     return true;
  //   } catch (e) {
  //     debugPrint("Forget Password Hatası: ${e.toString()}");
  //     return false;
  //   }
  // }

  // Future<bool> updateEmail(String newEmail, String password) async {
  //   try {
  //     final user = firebaseAuth.currentUser;
  //     final credential =
  //         EmailAuthProvider.credential(email: user!.email!, password: password);
  //     await user.reauthenticateWithCredential(credential);
  //     await user.updateEmail(newEmail);
  //     return true;
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     debugPrint("Update Email Hatası: ${e.toString()}");
  //     return false;
  //   }
  // }

  // Future<bool> resetPassword(String email) async {
  //   try {
  //     await firebaseAuth.sendPasswordResetEmail(email: email);
  //     return true;
  //   } catch (e) {
  //     debugPrint("resetPassword error: ${e.toString()}");
  //     return false;
  //   }
  // }
}
