import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatonparvlodar/roadmap/modules/step.dart';
import 'package:hackatonparvlodar/roadmap/services/steps.dart';

class RoadMap extends StatefulWidget {
  final String profession;
  const RoadMap({super.key, required this.profession});

  @override
  State<RoadMap> createState() => _RoadMapState();
}

class _RoadMapState extends State<RoadMap> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text('Бағдаржол', style: TextStyle(color: Colors.white)),
          leading: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blueGrey,
            ),

            child: Center(child: Icon(Icons.arrow_back, color: Colors.white)),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.blue[400],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '${widget.profession} профессиясына жол',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 30),

                  ProgressBar(done_value: 33),
                  choose(),
                ],
              ),
            ),
            StepWidget(
              stepOne: oneStep(
                title: 'Water the plants',
                id: 0,
                status: 'In process',
                subSteps: [
                  subStep(title: 'super', id: 0, status: false),
                  subStep(title: 'puper', id: 1, status: true),
                  subStep(title: 'mega', id: 2, status: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container choose() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.map),
                        SizedBox(width: 5),
                        Text('Жол'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.black, thickness: 1),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.video_collection_outlined),
                        SizedBox(width: 5),
                        Text('Видеолар'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey, thickness: 1),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatefulWidget {
  final int done_value;
  const ProgressBar({super.key, required this.done_value});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.done_value}% ',
                  style: TextStyle(color: Colors.blue),
                ),
                TextSpan(text: 'орындалды'),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: LinearProgressIndicator(
              value: widget.done_value / 100.toDouble(),
              minHeight: 30,
              borderRadius: BorderRadius.circular(3),
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
