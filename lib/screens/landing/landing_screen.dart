import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
          return; // The user canceled the sign-in
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        // Handle Redirect in User Provider
        // Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google: $e')),
        );
      }
    }

    return Scaffold(
      // backgroundColor: whiteBackgroundColor,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black!
          : whiteBackgroundColor,
      body: Stack(
        children: [
          // Background Ellipse
          Positioned(
            bottom: -350,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(-22.82 * 3.141592653589793 / 180),
              child: Container(
                width: 662,
                height: 750,
                decoration: BoxDecoration(
                  // color: Color(0xFF363536),
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
                CustomFullWidthButton(
                    label: "구글로 계속",
                    height: 59,
                    padding: 48,
                    onPressed: _signInWithGoogle),
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
                    // color: Colors.black,
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
