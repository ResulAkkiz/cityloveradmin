import 'package:cityloveradmin/pages/reportedcommentspage.dart';
import 'package:cityloveradmin/pages/reportedsharingspage.dart';
import 'package:cityloveradmin/pages/signuppage.dart';
import 'package:cityloveradmin/pages/userspage.dart';
import 'package:cityloveradmin/service/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                await userViewModel.signOut();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(12.0),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 8.0, childAspectRatio: 2, crossAxisCount: 1),
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(12.0)),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignupPage()));
                },
                icon: const Text('Admin Ekle')),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(12.0)),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReportedCommentPage(),
                    ),
                  );
                },
                icon: const Text('Raporlanmış Yorumlar')),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(12.0)),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportedSharingsPage()));
                },
                icon: const Text('Raporlanmış Paylaşımlar')),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(12.0)),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UsersPage()));
                },
                icon: const Text('Kullanıcılar')),
          ),
        ],
      ),
    );
  }
}

// SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: Container(
//             //         decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(12.0)),
//             //         child: const Text('Admin Ekle'))),
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: Container(
//             //         decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(12.0)),
//             //         child: const Text('Raporlanmış Yorumlar'))),
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: Container(
//             //         decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(12.0)),
//             //         child: const Text('Raporlanmış Paylaşımlar'))),
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: Container(
//             //         decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(12.0)),
//             //         child: const Text('Kullanıcılar'))),
//           ],
//         ),
//       ),
//     );