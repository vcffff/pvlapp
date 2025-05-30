import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/firstpage/footer.dart';
import 'package:hackatonparvlodar/firstpage/generatedprofession.dart';
import 'package:hackatonparvlodar/firstpage/learning2.dart';
import 'package:hackatonparvlodar/firstpage/list.dart';
import 'package:hackatonparvlodar/firstpage/secondpage.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [Header(), Listdart(), Generated(), Learningd(), Footer()],
        ),
      ),
    );
  }
}
