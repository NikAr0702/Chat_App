// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.onTap});

  // email and password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();

    //try login

    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    }
    // catch if their is any error
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                e.toString(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///Logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            ///Welcome Back Message

            Text(
              'Welcome back, you have been missed!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 25),

            ///Email textfield
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            ///password textfield
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 25),

            ///login button

            MyButton(
              buttonText: 'LOGIN',
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),

            ///regiter now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member ? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    '  Register now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).colorScheme.primary,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
