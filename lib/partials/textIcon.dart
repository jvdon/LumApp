import 'package:flutter/cupertino.dart';

class TextIcon extends StatelessWidget {
  final double width;
  final String text;
  final IconData icon;

  const TextIcon({super.key, required this.text, required this.icon, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
