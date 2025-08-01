import 'dart:ui' as book;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatonparvlodar/services/auth.dart';
import 'package:hackatonparvlodar/services/courseservice.dart';
import 'package:shimmer/shimmer.dart';

class Learningd extends StatefulWidget {
  const Learningd({super.key});

  @override
  State<Learningd> createState() => _LearningdState();
}

class _LearningdState extends State<Learningd> {
  List<String>? profes; // айди курсов
  List<String?>? titles; // названия курсов
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    loadprofes();
  }

  Future<void> loadprofes() async {
    final data = await fetchProfessions("Jane", "1234");
    setState(() {
      profes = data;
    });
    await loadTitles();
  }

  Future<void> loadTitles() async {
    final futures = profes!.map((id) => getCourseTitleById("Jane", id));
    final loadedTitles = await Future.wait(futures);
    setState(() {
      titles = loadedTitles;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profes == null || titles == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    book.Color.fromARGB(255, 57, 106, 205),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _buildProfessionRow(
                      context,
                      index: 0,
                      title: titles![0] ?? "no data",
                      progress: 0 / 32,
                      lessons: "0/48",
                    ),
                    _buildProfessionRow(
                      context,
                      index: 1,
                      title:
                          titles!.length > 1
                              ? titles![1]!.substring(0, 24)
                              : "no data",
                      progress: 0 / 21,
                      lessons: "0/32",
                    ),
                    _buildProfessionRow(
                      context,
                      index: 2,
                      title: titles![2]!,
                      progress: 0 / 36,
                      lessons: "0/21",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionRow(
    BuildContext context, {
    required int index,
    required String title,
    required double progress,
    required String lessons,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _selectedIndex = null;
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index
                  ? Colors.deepPurple.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.blue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      title[0],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B1B1D),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        color: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple.shade400,
                        ),
                        strokeWidth: 6.0,
                        backgroundColor: Colors.white,
                      ),
                      if (progress == 0)
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  lessons,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
