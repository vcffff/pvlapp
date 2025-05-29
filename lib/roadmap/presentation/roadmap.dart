import 'package:flutter/material.dart';

class RoadMap extends StatefulWidget {
  const RoadMap({super.key});

  @override
  State<RoadMap> createState() => _RoadMapState();
}

class _RoadMapState extends State<RoadMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  '${profession} профессиясына жол',
                  style: TextStyle(fontSize: 18),
                ),
                ProgressBar(done_value: dododo),
                Divider(color: Colors.grey),
              ],
            ),
          ),
          Container(
            
          )
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
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 20),
            children: <TextSpan>[
              TextSpan(text: '${widget.done_value}%'),
              TextSpan(text: 'орындалды'),
            ],
          ),
        ),
      ],
    );
    ;
  }
}
