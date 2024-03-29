import 'package:cityloveradmin/app_contants/app_extensions.dart';
import 'package:cityloveradmin/common_widgets/custom_model_sheet.dart';
import 'package:cityloveradmin/service/firebase_auth_service.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset('assets/images/im_city.png',
                              scale: 2)),
                      TextFormField(
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
                      ElevatedButton(
                        onPressed: () async {
                          formKey.currentState!.save();
                          if (formKey.currentState!.validate()) {
                            var user = await userViewModel.signInEmailPassword(
                                emailController.text, passwordController.text);
                            if (userViewModel.user != null) {
                              var usermodel =
                                  await userViewModel.readUser(user!.userID);
                              debugPrint(usermodel.toString());
                              if (usermodel!.role != 1) {
                                await userViewModel.signOut();
                              }
                            } else {
                              if (mounted) {
                                buildShowModelBottomSheet(context, errorMessage,
                                    Icons.question_mark_outlined);
                                errorMessage = '';
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const StadiumBorder()),
                        child: const Text('Giriş Yap'),
                      )
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
    );
  }
}
