import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/roadmap/services/steps.dart';

class StepWidget extends StatelessWidget {
  final oneStep stepOne;
  const StepWidget({super.key, required this.stepOne});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(stepOne.title!),
        ),
        stepOne.subSteps.isNotEmpty
            ? Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: stepOne.subSteps.length,
                  itemBuilder: (context, index) {
                    final subStep = stepOne.subSteps[index];
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Text(subStep.title!),
                    );
                  },
                ),
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
