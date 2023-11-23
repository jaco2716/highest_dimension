import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highest_dimension/constants/style_config.dart';
import 'package:highest_dimension/model/providers/app_data_provider.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/providers/auth_app_state.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataProvider>(create: (context) => AppDataProvider()),
        ChangeNotifierProvider<AuthAppState>(create: (context) => AuthAppState()),
      ],
      child: const MyApp(),
    ),
    // const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> getData;
  @override
  void initState() {
    getData = context.read<AppDataProvider>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        appBarTheme: const AppBarTheme(
          // actionsIconTheme: IconThemeData(color: primaryColor),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(color: primaryColor),
          iconTheme: IconThemeData(color: primaryColor),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
      ),
      home: FutureBuilder(
          future: getData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // FlutterNativeSplash.remove();
              return const MyHomePage();
            }
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }),
      // home: const MyHomePage(),
    );
  }
}
