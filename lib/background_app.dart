import 'package:flutter/material.dart';

class BackgroundApp extends StatelessWidget {
  final Widget child;

  const BackgroundApp({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background-peliculas.jpg'),
          repeat: ImageRepeat.repeat,
          fit: BoxFit.none,
        ),
      ),
      child: child,
    );
  }
}
