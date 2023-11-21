import 'package:flutter/material.dart';
import 'package:highest_dimension/pages/home/quote_page_view.dart';
import 'package:highest_dimension/pages/settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
              icon: const Icon(Icons.settings_rounded)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            // scale: 2,
            image: AssetImage("assets/images/background.png"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/images/pearl_icon.png", width: 80),
              const SizedBox(height: 0, width: double.infinity),
              const Expanded(child: QuotePageView()),
            ],
          ),
        ),
      ),
    );
  }
}
