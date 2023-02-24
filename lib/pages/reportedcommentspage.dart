import 'package:cityloveradmin/app_contants/app_extensions.dart';
import 'package:cityloveradmin/app_contants/string_generator.dart';
import 'package:cityloveradmin/common_widgets/custom_model_sheet.dart';
import 'package:cityloveradmin/models/commentmodel.dart';
import 'package:cityloveradmin/models/usermodel.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportedCommentPage extends StatefulWidget {
  const ReportedCommentPage({super.key});

  @override
  State<ReportedCommentPage> createState() => _ReportedCommentPageState();
}

class _ReportedCommentPageState extends State<ReportedCommentPage> {
  bool isSharingsReady = false;

  @override
  void initState() {
    getComments();
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
          child: isSharingsReady
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    CommentModel currentComment =
                        userViewModel.reportedCommentList[index];
                    return FutureBuilder(
                        future: userViewModel.readUser(currentComment.userID),
                        builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                          if (snapshot.hasData) {
                            var currentUser = snapshot.data;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      currentUser!.userProfilePict!),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${currentUser.userName!.trim()} ${currentUser.userSurname!}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      currentUser.userEmail,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      currentComment.commentContent,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm•dd/MM/yyyy')
                                          .format(currentComment.commentDate),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Paylaşım ID: ${currentComment.sharingID}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              bool response = await buildShowDialog(
                                                      context,
                                                      const Text('Uyarı'),
                                                      const Text(
                                                          'Seçmiş olduğunuz yorumu, raporlama listesinden kaldırmak istediğinizden emin misiniz ?')) ??
                                                  false;

                                              if (response) {
                                                bool isSuccessful =
                                                    await userViewModel
                                                        .checkComment(
                                                            currentComment);
                                                if (isSuccessful && mounted) {
                                                  buildShowModelBottomSheet(
                                                      context,
                                                      'İşlem başarıyla gerçekleşti.',
                                                      Icons.done_outlined);
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              bool response = await buildShowDialog(
                                                      context,
                                                      const Text('Uyarı'),
                                                      const Text(
                                                          'Seçmiş olduğunuz yorumu, silmek istediğinizden emin misiniz ?')) ??
                                                  false;

                                              if (response) {
                                                bool isSuccessful =
                                                    await userViewModel
                                                        .deleteComment(
                                                            currentComment);
                                                if (isSuccessful && mounted) {
                                                  buildShowModelBottomSheet(
                                                      context,
                                                      'İşlem başarıyla gerçekleşti.',
                                                      Icons.done_outlined);
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                            )),
                                      ],
                                    )
                                  ],
                                ).separated(
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: Colors.red,
                            );
                          }
                        });
                  },
                  itemCount: userViewModel.reportedCommentList.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Future<void> getComments() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.getReportedComments();
    isSharingsReady = true;
  }
}
