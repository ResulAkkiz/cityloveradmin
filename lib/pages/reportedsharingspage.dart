import 'package:cityloveradmin/app_contants/app_extensions.dart';
import 'package:cityloveradmin/app_contants/string_generator.dart';
import 'package:cityloveradmin/common_widgets/custom_model_sheet.dart';
import 'package:cityloveradmin/models/sharingmodel.dart';
import 'package:cityloveradmin/models/usermodel.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportedSharingsPage extends StatefulWidget {
  const ReportedSharingsPage({super.key});

  @override
  State<ReportedSharingsPage> createState() => _ReportedSharingsPageState();
}

class _ReportedSharingsPageState extends State<ReportedSharingsPage> {
  bool isSharingsReady = false;

  @override
  void initState() {
    getSharings();
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
                    SharingModel currentSharing =
                        userViewModel.reportedSharingList[index];
                    return FutureBuilder(
                        future: userViewModel.readUser(currentSharing.userID),
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
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${currentUser.userName!.trim()} ${currentUser.userSurname!}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          currentSharing.sharingContent,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm•dd/MM/yyyy').format(
                                              currentSharing.sharingDate),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          '${currentSharing.countryName} / ${currentSharing.cityName}',
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
                                                  {
                                                    bool response =
                                                        await buildShowDialog(
                                                                context,
                                                                const Text(
                                                                    'Uyarı'),
                                                                const Text(
                                                                    'Seçmiş olduğunuz paylaşımı, raporlama listesinden kaldırmak istediğinizden emin misiniz ?')) ??
                                                            false;

                                                    if (response) {
                                                      bool isSuccessful =
                                                          await userViewModel
                                                              .checkSharing(
                                                                  currentSharing);
                                                      if (isSuccessful &&
                                                          mounted) {
                                                        buildShowModelBottomSheet(
                                                            context,
                                                            'İşlem başarıyla gerçekleşti.',
                                                            Icons
                                                                .done_outlined);
                                                      }
                                                    }
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  bool response =
                                                      await buildShowDialog(
                                                              context,
                                                              const Text(
                                                                  'Uyarı'),
                                                              const Text(
                                                                  'Seçmiş olduğunuz paylaşımı, silmek istediğinizden emin misiniz ?')) ??
                                                          false;

                                                  if (response) {
                                                    bool isSuccessful =
                                                        await userViewModel
                                                            .deleteSharing(
                                                                currentSharing);
                                                    if (isSuccessful &&
                                                        mounted) {
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
                                  )),
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
                  itemCount: userViewModel.reportedSharingList.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Future<void> getSharings() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.getReportedSharings();
    isSharingsReady = true;
  }
}
