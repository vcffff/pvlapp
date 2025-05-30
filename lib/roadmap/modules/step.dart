import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/roadmap/services/steps.dart';

class StepWidget extends StatefulWidget {
  final String stepOne;
  final String roadmap;

  const StepWidget({super.key, required this.stepOne, required this.roadmap});

  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  late String selectedValue;
  int completeSubSteps = 0;
  @override
  void initState() {
    super.initState();
    selectedValue = 'In process';
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = ['Done', 'In process', 'Skipped'];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Make text flexible and allow wrapping
              Expanded(
                child: Text(
                  widget.roadmap,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
              ),
              SizedBox(width: 10),
              Divider(color: Colors.black, thickness: 1),
            ],
          ),
        ),
      ],
    );
  }
}
