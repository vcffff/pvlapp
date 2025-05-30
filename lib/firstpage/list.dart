import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatonparvlodar/detailprofession.dart';
import 'package:hackatonparvlodar/list/list_words_images';
import 'package:hackatonparvlodar/services/auth.dart';
import 'package:hackatonparvlodar/services/courseservice.dart';
import 'package:shimmer/shimmer.dart';

class Listdart extends StatefulWidget {
  const Listdart({super.key});

  @override
  State<Listdart> createState() => _ListdartState();
}

class _ListdartState extends State<Listdart> {
  List<String> profes = [];
  List<Map<String, dynamic>> professions = [];
  List<String> words = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedIndex;
  Map<String, dynamic>? profession;

  @override
  void initState() {
    super.initState();
    loadProfessions();
  }

  Future<void> loadProfessions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await fetchProfessions("Jane", "1234");
      if (data == null || data.isEmpty) {
        setState(() {
          _error = 'Нет доступных профессий';
          _isLoading = false;
        });
        return;
      }
      setState(() {
        profes = data;
      });
      await loadCourses();
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки профессий: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> loadCourses() async {
    List<Map<String, dynamic>> loadedProfessions = [];
    for (String id in profes) {
      final professionData = await getCourseDataById(id);
      final coursesData = await getCoursesByProfessionId(id);
      profession = professionData;
      loadedProfessions.add({
        'id': id,
        'name': professionData?['name'] as String? ?? 'Нет данных',
        'courses': coursesData ?? [],
      });
    }
    setState(() {
      professions = loadedProfessions;
      words =
          professions
              .map((p) => p['name'] as String? ?? 'Нет данных')
              .whereType<String>()
              .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingShimmer();
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loadProfessions,
              child: Text('Повторить', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    }
    if (words.isEmpty || images.isEmpty) {
      return Center(
        child: Text(
          'Нет данных для отображения',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: words.length < images.length ? words.length : images.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'profession-image-${images[index]}',
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DetailPage(
                          profession: words[index],
                          imageUrl: images[index],
                          courses:
                              professions[index]['courses']
                                  as List<Map<String, dynamic>>? ??
                              [],
                        ),
                  ),
                ).then((_) {
                  setState(() {
                    _selectedIndex = null;
                  });
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 15),
                width: 290,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(images[index]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade100, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border:
                      _selectedIndex == index
                          ? Border.all(color: Colors.deepPurple, width: 2.5)
                          : Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 180,
                        width: 290,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.withOpacity(0.15),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 15,
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          words[index],
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    if (_selectedIndex == index)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.deepPurple.withOpacity(0.1),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              width: 290,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
