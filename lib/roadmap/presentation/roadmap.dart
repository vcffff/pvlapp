import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatonparvlodar/firstpage/services/suggest_service.dart';
import 'package:hackatonparvlodar/roadmap/modules/step.dart';
import 'package:hackatonparvlodar/roadmap/services/steps.dart';

class RoadMap extends StatefulWidget {
  final EngineeringSpecialty profession;
  const RoadMap({super.key, required this.profession});

  @override
  State<RoadMap> createState() => _RoadMapState();
}

class _RoadMapState extends State<RoadMap> {
  final Dio _dio = Dio();
  List<String> lessons = [];
  bool isLoading = true;
  String errorMessage = '';
  String courseTitle = '';
  String lessonTitle = '';
  @override
  Future<void> fetchVideos() async {
    try {
      final response = await _dio.get(
        'https://helpai-server.vercel.app/api/lessons',
      );
      setState(() {
        final data = response.data;
        lessons = List<String>.from(data['course']['lessons']);
        courseTitle = data['course']['title'];
        lessonTitle = data['title'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load videos: $e';
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text('Бағдаржол', style: TextStyle(color: Colors.white)),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
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
                      '${widget.profession.name} профессиясына жол',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  choose(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.profession.roadmap.length,
                itemBuilder: (context, index) {
                  return StepWidget(
                    stepOne: widget.profession.name,
                    roadmap: widget.profession.roadmap[index],
                  );
                },
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
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.map),
                          SizedBox(width: 5),
                          Text('Жол'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 100,
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}
