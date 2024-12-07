import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';
import 'package:moapp_toto/constants.dart';
import 'package:moapp_toto/widgets/custom_button.dart';
import 'package:moapp_toto/widgets/custom_full_button.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future<void> _signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        // Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : whiteBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            bottom: -350,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(-22.82 * 3.141592653589793 / 180),
              child: Container(
                width: 662,
                height: 750,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Color(0xFF363536),
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(662 / 2, 750 / 2),
                  ),
                ),
              ),
            ),
          ),
          // Foreground
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rive Animation
                SizedBox(
                  height: 215,
                  width: 215,
                  child: RiveAnimation.asset(
                    'animations/cat_following_the_mouse.riv',
                    fit: BoxFit.contain,
                  ),
                ),
                CustomFullWidthButton(
                  label: "구글로 계속",
                  height: 59,
                  padding: 48,
                  onPressed: _signInWithGoogle,
                ),
                SizedBox(height: 32),
                Text(
                  "개발의 정석",
                  style: TextStyle(color: Color(0xBFFFFFFF)),
                ),
                SizedBox(height: 22)
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TODAY,\nTOGETHER',
                  style: TextStyle(
                    fontSize: 48,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[100]!
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 400)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
