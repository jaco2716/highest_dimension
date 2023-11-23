import 'dart:async';

import 'package:flutter/material.dart';
import 'package:highest_dimension/pages/admin_login_page.dart';
import 'package:highest_dimension/pages/manage_quotes_page.dart';
import 'package:highest_dimension/widgets/my_elevated_button.dart';
import 'package:provider/provider.dart';

import '../model/providers/auth_app_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int tapCounter = 0;

  Timer? _timer;

  void hiddenTapped() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      tapCounter = 0;
    });
    if (_timer?.isActive ?? false) tapCounter++;

    if (tapCounter > 9) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
      // var controller = TextEditingController();
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return MyInfoDialog(
      //       title: 'Access Admin Settings',
      //       action: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           TextButton(
      //               onPressed: () {
      //                 Navigator.maybePop(context);
      //               },
      //               child: const Text('Cancel')),
      //           ElevatedButton(
      //               child: const Text('Activate'),
      //               onPressed: () {
      //                 if (controller.text == 'JK1406') {
      //                   Navigator.pop(context);
      //                   context.read<AppDataProvider>().setAdvancedSettings(true);
      //                   showDialog(
      //                     context: context,
      //                     builder: (context) {
      //                       return const MyInfoDialog(child: Text('Advanced Settings activated'));
      //                     },
      //                   );
      //                 }
      //               }),
      //         ],
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           TextFormField(
      //             controller: controller,
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          GestureDetector(
            onTap: hiddenTapped,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            // scale: 2,
            image: AssetImage("assets/images/background.png"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyElevatedButton(
                  title: 'Notification Settings',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageQuotesPage(),
                        ));
                  }),
              const SizedBox(height: 20),
              MyElevatedButton(
                  title: 'Support',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageQuotesPage(),
                        ));
                  }),
              const SizedBox(height: 20),
              Consumer<AuthAppState>(
                builder: (context, appState, _) {
                  if (appState.loginState == ApplicationLoginState.loggedIn) {
                    return MyElevatedButton(
                        title: 'Manage Quotes',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManageQuotesPage(),
                              ));
                        });
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
