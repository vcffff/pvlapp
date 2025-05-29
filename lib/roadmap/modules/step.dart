import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/roadmap/services/steps.dart';

class StepWidget extends StatefulWidget {
  final oneStep stepOne;

  const StepWidget({super.key, required this.stepOne});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '• ${widget.stepOne.title!}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 7, bottom: 7, right: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items:
                        items.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.stepOne.status = newValue!;
                        selectedValue = newValue;
                        print(widget.stepOne.status);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        widget.stepOne.subSteps.isNotEmpty
            ? Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: widget.stepOne.subSteps.length,
                itemBuilder: (context, index) {
                  final subStep = widget.stepOne.subSteps[index];
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          widget.stepOne.subSteps[index].status
                              ? Colors.grey
                              : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 0.3),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    margin: EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                child: Text(
                                  '${index + 1}.',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Text(
                                '${subStep.title!}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (widget.stepOne.subSteps[index].status) {
                                widget.stepOne.subSteps[index].status = false;
                              } else if (!widget
                                  .stepOne
                                  .subSteps[index]
                                  .status) {
                                widget.stepOne.subSteps[index].status = true;
                              }
                            });
                          },

                          icon:
                              widget.stepOne.subSteps[index].status
                                  ? Icon(Icons.circle)
                                  : Icon(Icons.circle_outlined),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
