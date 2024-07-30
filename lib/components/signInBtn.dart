import 'package:flutter/material.dart';

class SignInBtn extends StatelessWidget {

  final Function()? onTap;

  const SignInBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        decoration: BoxDecoration(
          color: Colors.black, 
          borderRadius: BorderRadius.circular(16)
        ),
        child: Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            ),
          )
        ),
      ),
    );
  }
}