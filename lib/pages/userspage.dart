import 'package:cityloveradmin/app_contants/app_extensions.dart';
import 'package:cityloveradmin/common_widgets/custom_model_sheet.dart';
import 'package:cityloveradmin/models/usermodel.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserModel> usersList = [];
  bool isUsersReady = false;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: isUsersReady
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    UserModel currentUser = userViewModel.userList[index];
                    return ListTile(
                      textColor:
                          currentUser.status! ? Colors.black : Colors.red,
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(currentUser.userProfilePict!),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${currentUser.userID}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Ad-Soyad: ${currentUser.userName!} ${currentUser.userSurname!}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'E-mail: ${currentUser.userEmail}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Doğum Tarihi :${DateFormat('dd/MM/yyyy').format(currentUser.userBirthdate!)}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            currentUser.userGender == '0'
                                ? 'Cinsiyet: Erkek'
                                : 'Cinsiyet: Kadın',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentUser.status!
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.block,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        bool isSuccessful = await userViewModel
                                            .updateUser(currentUser.userID,
                                                {'status': false});

                                        if (isSuccessful && mounted) {
                                          buildShowModelBottomSheet(
                                              context,
                                              'Blocklama işlemi başarıyla gerçekleşti.',
                                              Icons.done_outlined);
                                          await userViewModel.readAllUsers();
                                        }
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        bool isSuccessful = await userViewModel
                                            .updateUser(currentUser.userID,
                                                {'status': true});

                                        if (isSuccessful && mounted) {
                                          buildShowModelBottomSheet(
                                              context,
                                              'Block kaldırma işlemi başarıyla gerçekleşti.',
                                              Icons.done_outlined);
                                          await userViewModel.readAllUsers();
                                        }
                                      },
                                    )
                            ],
                          )
                        ],
                      ).separated(const SizedBox(
                        height: 8,
                      )),
                    );
                  },
                  itemCount: userViewModel.userList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(thickness: 1.2);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Future<void> getUsers() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.readAllUsers();
    isUsersReady = true;
  }
}
