import 'package:cityloveradmin/pages/homepage.dart';
import 'package:cityloveradmin/pages/loginpage.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    if (userViewModel.user == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}
