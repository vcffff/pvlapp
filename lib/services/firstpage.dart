import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/footer.dart';
import 'package:hackatonparvlodar/learning2.dart';
import 'package:hackatonparvlodar/list.dart';
import 'package:hackatonparvlodar/services/secondpage.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Header(), Listdart(), Learningd(), Footer()]);
  }
}
