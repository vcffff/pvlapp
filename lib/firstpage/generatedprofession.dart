import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/firstpage/suggestions.dart';

class Generated extends StatelessWidget {
  const Generated({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Suggestion()),
        );
      },
      child: Container(
        width: double.maxFinite,
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.blue[400],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'ЖИ - қеңестері',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
