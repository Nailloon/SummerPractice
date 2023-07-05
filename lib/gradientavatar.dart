import 'package:flutter/material.dart';

class GradientCircleAvatar extends StatelessWidget {
  final String? avatar;
  final Gradient gradient;
  final String text;

  const GradientCircleAvatar({
    Key? key,
    required this.avatar,
    required this.gradient,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: 25,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
            image: avatar != null
                ? DecorationImage(
                    image: AssetImage('assets/avatars/${avatar}'),
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          child: avatar == null
              ? Center(
                  child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))
              : null,
        ),
      );
}
