import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential = await auth.signInWithCredential(authCredential);
        return userCredential.user;
      } else {
        print("Google sign-in was aborted by the user.");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      print("General Exception: ${e.toString()}");
      return null;
    }
  }

  // Sign out
  Future<void> googleSignOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
