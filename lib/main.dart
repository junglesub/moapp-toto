import 'package:flutter/material.dart';
import 'package:moapp_toto/provider/appstate.dart';
import 'package:moapp_toto/screens/add/add_screen.dart';
import 'package:moapp_toto/screens/friend/friend_screen.dart';
import 'package:moapp_toto/screens/home/home_screen.dart';
import 'package:moapp_toto/screens/landing/landing_screen.dart';
import 'package:moapp_toto/screens/mission/mission_screen.dart';
import 'package:moapp_toto/screens/profile/profile_screen.dart';
import 'package:moapp_toto/screens/signUp/signUp_screen.dart';
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
        initialRoute: '/profile',
        routes: {
          '/landing': (BuildContext context) => const LandingPage(),
          '/signup': (BuildContext context) => const SignUpPage(),
          '/': (BuildContext context) => const HomePage(),
          '/add': (BuildContext context) => const AddPage(),
          '/friend': (BuildContext context) => const FriendPage(),
          '/mission': (BuildContext context) => const MissionPage(),
          '/profile': (BuildContext context) => const ProfilePage(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF363536),
            surface: const Color(0xFFFFFFF5),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF363536),
            foregroundColor: Color(0xFFFFFFF5),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Color(0xFF363536),
          ),
        ),
      ),
    );
  }
}
