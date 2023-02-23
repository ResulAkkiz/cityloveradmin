import 'package:cityloveradmin/app_contants/app_extensions.dart';
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
                    UserModel currentUser = usersList[index];
                    return ListTile(
                      onTap: () {},
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
                                      icon: const Icon(Icons.block),
                                      onPressed: () {},
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.check),
                                      onPressed: () {},
                                    )
                            ],
                          )
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         const Icon(
                          //           Icons.comment,
                          //           size: 16,
                          //         ),
                          //         const SizedBox(
                          //           width: 4,
                          //         ),
                          //         FutureBuilder(
                          //             future: userViewModel
                          //                 .getCommentsList(currentSharing.sharingID),
                          //             builder: (context, AsyncSnapshot snapshot) {
                          //               if (snapshot.hasData) {
                          //                 List<CommentModel> commentList =
                          //                     snapshot.data;
                          //                 int listLength = commentList.length;
                          //                 return Text(
                          //                   listLength.toString(),
                          //                   style: const TextStyle(
                          //                     color: Colors.black54,
                          //                     fontSize: 12,
                          //                   ),
                          //                 );
                          //               } else if (snapshot.hasError) {
                          //                 return Center(
                          //                     child: Text(snapshot.error.toString()));
                          //               } else {
                          //                 return const Center(
                          //                   child: CircularProgressIndicator(),
                          //                 );
                          //               }
                          //             }),
                          //         Builder(
                          //           builder: (context) {
                          //             if (userViewModel.user != null) {
                          //               if (currentSharing.userID !=
                          //                   userViewModel.user!.userID) {
                          //                 return IconButton(
                          //                   padding: EdgeInsets.zero,
                          //                   onPressed: () async {
                          //                     bool response = await buildShowDialog(
                          //                             context,
                          //                             const Text('Uyarı'),
                          //                             const Text(
                          //                                 'Seçmiş olduğunuz paylaşımı, raporlamak istediğinizden emin misiniz ?')) ??
                          //                         false;
                          //                     if (response) {
                          //                       bool isSuccessful =
                          //                           await userViewModel.reportSharing(
                          //                               currentSharing);
                          //                       debugPrint(isSuccessful.toString());
                          //                       if (isSuccessful && mounted) {
                          //                         buildShowModelBottomSheet(
                          //                             context,
                          //                             'Raporlama işlemi başarıyla gerçekleşti. İnceleme sonucu gerekli aksiyonlar alınacaktır.',
                          //                             Icons.report_problem);
                          //                       }
                          //                     }
                          //                   },
                          //                   constraints: const BoxConstraints(),
                          //                   icon: const Icon(
                          //                     Icons.report_problem_outlined,
                          //                     size: 14,
                          //                   ),
                          //                 );
                          //               } else {
                          //                 return IconButton(
                          //                   padding: EdgeInsets.zero,
                          //                   onPressed: () async {
                          //                     bool response = await buildShowDialog(
                          //                             context,
                          //                             const Text('Uyarı'),
                          //                             const Text(
                          //                                 'Seçmiş olduğunuz paylaşımı, silmek istediğinizden emin misiniz ?')) ??
                          //                         false;

                          //                     if (response) {
                          //                       bool isSuccesful = await userViewModel
                          //                           .deleteSharing(currentSharing);
                          //                       if (isSuccesful && mounted) {
                          //                         buildShowModelBottomSheet(
                          //                             context,
                          //                             'Paylaşım silme işlemi başarıyla gerçekleşti.',
                          //                             Icons.check);
                          //                       }
                          //                     }
                          //                   },
                          //                   constraints: const BoxConstraints(),
                          //                   icon: const Icon(
                          //                     Icons.clear,
                          //                     size: 14,
                          //                   ),
                          //                 );
                          //               }
                          //             } else {
                          //               return const SizedBox();
                          //             }
                          //           },
                          //         )
                          //       ],
                          //     ),
                          //   ],
                          // )
                        ],
                      ).separated(const SizedBox(
                        height: 8,
                      )),
                    );
                  },
                  itemCount: usersList.length,
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
    usersList = await userViewModel.readAllUsers();
    isUsersReady = true;
    setState(() {});
  }
}
