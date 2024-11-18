import 'package:flutter/material.dart';
import 'package:moapp_toto/provider/appstate.dart';
import 'package:moapp_toto/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: '투데이투게더',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => const HomePage(),
        },
        theme: ThemeData.light(useMaterial3: true)
            .copyWith(primaryColor: Colors.blue),
      ),
    );
  }
}
