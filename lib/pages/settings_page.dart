import 'package:flutter/material.dart';
import 'package:highest_dimension/pages/manage_quotes_page.dart';
import 'package:highest_dimension/widgets/my_elevated_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            children: [
              MyElevatedButton(
                  title: 'Manage Quotes',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageQuotesPage(),
                        ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
