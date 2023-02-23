import 'package:cityloveradmin/models/adminmodel.dart';
import 'package:cityloveradmin/models/commentmodel.dart';
import 'package:cityloveradmin/models/sharingmodel.dart';
import 'package:cityloveradmin/models/usermodel.dart';
import 'package:cityloveradmin/service/firebase_auth_service.dart';
import 'package:cityloveradmin/service/firebase_db_service.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  AdminModel? _user;

  AdminModel? get user => _user;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirebaseDbService firebaseDbService = FirebaseDbService();

  UserViewModel() {
    debugPrint('userviewmodel constructor method tetiklendi');
    currentUser();
  }
  List<CommentModel> reportedCommentList = [];
  List<SharingModel> reportedSharingList = [];
  List<CommentModel> commentList = [];
  List<SharingModel> sharingList = [];
  List<UserModel> userList = [];

  Future<AdminModel?> createEmailPassword({
    required String email,
    required String password,
  }) async {
    _user = await firebaseAuthService.createEmailPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    if (_user != null) {
      firebaseDbService.saveUser(_user!);
    }
    return _user;
  }

  Future<List<UserModel>> readAllUsers() async {
    userList = await firebaseDbService.readAllUsers();
    notifyListeners();
    return userList;
  }

  Future<AdminModel?> currentUser() async {
    _user = await firebaseAuthService.currentUser();
    notifyListeners();
    return _user;
  }

  Future<AdminModel?> signInEmailPassword(String email, String password) async {
    _user = await firebaseAuthService.signInEmailPassword(email, password);
    notifyListeners();
    return _user;
  }

  Future<bool?> signOut() async {
    _user = null;
    notifyListeners();
    return await firebaseAuthService.signOut();
  }

  Future<List<CommentModel>> getReportedComments() async {
    reportedCommentList = await firebaseDbService.getReportedComments();
    notifyListeners();
    return reportedCommentList;
  }

  Future<List<SharingModel>> getReportedSharings() async {
    reportedSharingList = await firebaseDbService.getReportedSharings();
    notifyListeners();
    return reportedSharingList;
  }

  Future<bool> saveUser(AdminModel user) async {
    return await firebaseDbService.saveUser(user);
  }

  Future<UserModel?> readUser(String userId) async {
    return await firebaseDbService.readUser(userId);
  }

  Future<void> getSharingsbyLocation(
      String countryValue, String cityValue) async {
    sharingList =
        await firebaseDbService.getSharingsbyLocation(countryValue, cityValue);
    debugPrint(sharingList.length.toString());
    notifyListeners();
  }

  Future<void> getComments(String sharingID) async {
    commentList = await firebaseDbService.getComments(sharingID);
    notifyListeners();
  }

  Future<List<CommentModel>> getCommentsList(String sharingID) async {
    return await firebaseDbService.getComments(sharingID);
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> newMap) async {
    return firebaseDbService.updateUser(userId, newMap);
  }

  // Future<bool> resetPassword(String email) async {
  //   return await firebaseAuthService.resetPassword(email);
  // }

  // Future<bool> updateEmail(String newEmail, String password) async {
  //   return await firebaseAuthService.updateEmail(newEmail, password);
  // }

  Future<bool> checkSharing(SharingModel sharingModel) async {
    bool isSuccesful = await firebaseDbService.checkSharing(sharingModel);
    getReportedSharings();
    return isSuccesful;
  }

  Future<bool> checkComment(CommentModel commentModel) async {
    bool isSuccesful = await firebaseDbService.checkComment(commentModel);
    getReportedComments();
    return isSuccesful;
  }

  Future<bool> deleteComment(CommentModel commentModel) async {
    bool isSuccesful = await firebaseDbService.deleteComment(commentModel);
    getReportedComments();
    return isSuccesful;
  }

  Future<bool> deleteSharing(SharingModel sharingModel) async {
    bool isSuccesful = await firebaseDbService.deleteSharing(sharingModel);
    getReportedSharings();
    return isSuccesful;
  }
}
