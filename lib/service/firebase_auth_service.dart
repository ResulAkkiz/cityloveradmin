import 'package:cityloveradmin/app_contants/string_generator.dart';
import 'package:cityloveradmin/models/country_model.dart';
import 'package:cityloveradmin/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String errorMessage = '';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> createEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      errorMessage = '';
      return userCredential.user != null
          ? UserModel(
              userID: userCredential.user!.uid,
              userEmail: userCredential.user!.email!,
              status: true,
              userGender: '0',
              userName: 'Admin',
              userSurname: getRandomString(6),
              userProfilePict:
                  'https://firebasestorage.googleapis.com/v0/b/citylover-a0f89.appspot.com/o/32QXZ91QqLxi%2F9336cbc0-207a-4980-b5d4-7e86786eb43b.png?alt=media&token=6b984a73-ed8b-4cbf-8610-e11d2f92df73',
              userBirthdate: DateTime.now(),
              lastCountry: LocationModel(id: '1', name: 'Afganistan'),
              lastState: LocationModel(id: '1', name: 'Badakhshan'),
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

  UserModel? userToUserModel(User? user) {
    if (user != null) {
      return UserModel(
        userID: user.uid,
        userEmail: user.email ?? '',
      );
    } else {
      return null;
    }
  }

  Future<UserModel?> currentUser() async {
    try {
      var user = firebaseAuth.currentUser;
      return userToUserModel(user);
    } catch (e) {
      debugPrint("CurrentUser Hatası: ${e.toString()}");
      return null;
    }
  }

  Future<UserModel?> signInEmailPassword(String email, String sifre) async {
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
