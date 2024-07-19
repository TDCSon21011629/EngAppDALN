import 'package:eng_app/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widget/Login/button.dart';
import '../services/google_auth.dart';
import '../services/forgot_password.dart';
import '../services/authentication.dart';
import '../Widget/Login/snackbar.dart';
import '../Widget/Login/text_field.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => mainPage(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    User? user = await FirebaseServices().signInWithGoogle();
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => mainPage(),
        ),
      );
    } else {
      showSnackBar(context, "Failed to sign in with Google");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height / 2.7, child: Image.asset('images/logo1.jpg')),
                  TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text,
                  ),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const ForgotPassword(),
                  MyButtons(onTap: loginUser, text: "Log In"),
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.black26)),
                      const Text("  or  "),
                      Expanded(child: Container(height: 1, color: Colors.black26))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: loginWithGoogle,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Image.network(
                              "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                              height: 35,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
