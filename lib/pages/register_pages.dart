import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;

  //register
  void register(BuildContext context) {
    //get auth service

    final auth = AuthService();

    //create user if their pw and cnfpw is same

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
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
      //password don't match
    } else {
      showDialog(
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                'Password don\'t match',
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
              'Let\'s create an account for you!',
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

            /// cnf password textfield

            const SizedBox(height: 10),

            MyTextField(
              hintText: 'Confirm password',
              obscureText: true,
              controller: _confirmPasswordController,
            ),

            const SizedBox(height: 25),

            ///login button

            MyButton(
              buttonText: 'REGISTER',
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),

            ///regiter now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account ? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    ' Login now',
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
