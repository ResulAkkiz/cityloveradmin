import 'package:cityloveradmin/app_contants/app_extensions.dart';
import 'package:cityloveradmin/app_contants/custom_theme.dart';
import 'package:cityloveradmin/common_widgets/custom_model_sheet.dart';
import 'package:cityloveradmin/models/adminmodel.dart';
import 'package:cityloveradmin/service/firebase_auth_service.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(35),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Lütfen e-mail adresinizi giriniz.";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                              hintText: 'E-mail', labelText: 'E-mail'),
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                          controller: passwordController,
                          obscureText: obscurePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Lütfen şifrenizi giriniz.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Şifre',
                            labelText: 'Şifre',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                }
                              },
                              child: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                formKey.currentState!.save();
                                if (formKey.currentState!.validate()) {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24.0),
                                          topRight: Radius.circular(24.0)),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: twitterBlue,
                                            ),
                                          ));
                                    },
                                  );
                                  AdminModel? userModel =
                                      await userViewModel.createEmailPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  if (userModel != null) {
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } else {
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      buildShowModelBottomSheet(context,
                                          errorMessage, Icons.dangerous);
                                    }
                                    errorMessage = '';
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const StadiumBorder()),
                              child: const Text('Admin Ekle'),
                            ),
                          ],
                        ),
                      ],
                    ).separated(const SizedBox(
                      height: 16,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
