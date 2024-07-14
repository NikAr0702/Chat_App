import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.buttonText, this.onTap});

  final String buttonText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLightMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
              fontSize: 16, color: isLightMode ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
