import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPage extends StatefulWidget {
  final String profession;
  final String imageUrl;
  final List<Map<String, dynamic>> courses;

  const DetailPage({
    super.key,
    required this.profession,
    required this.imageUrl,
    required this.courses,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  List<Map<String, dynamic>> videoControllers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    // Initialize YouTube player controllers
    for (var course in widget.courses) {
      final lessons = course['lessons'] as List<dynamic>? ?? [];
      for (var lesson in lessons) {
        final link = lesson['link'] as String? ?? '';
        final videoId = YoutubePlayer.convertUrlToId(link) ?? '';
        if (videoId.isNotEmpty) {
          final controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              enableCaption: true,
              loop: false,
            ),
          );
          videoControllers.add({
            'controller': controller,
            'lessonId': lesson['id'] as String? ?? '',
            'courseId': course['id'] as String? ?? '',
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var item in videoControllers) {
      (item['controller'] as YoutubePlayerController).dispose();
    }
    super.dispose();
  }

  Future<List<Map<String, dynamic>>?> fetchVideo({String? professionId}) async {
    try {
      final dio = Dio();
      final url =
          professionId != null
              ? 'https://helpai-server.vercel.app/api/lessons?professionId=$professionId'
              : 'https://helpai-server.vercel.app/api/lessons';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List<dynamic>) {
          final Map<String, Map<String, dynamic>> courses = {};
          for (var lesson in data) {
            final course = lesson['course'] as Map<String, dynamic>?;
            if (course == null) continue;

            final courseId = course['_id'] as String? ?? '';
            if (!courses.containsKey(courseId)) {
              courses[courseId] = {
                'id': courseId,
                'title': course['title'] as String? ?? 'Без названия',
                'description':
                    course['description'] as String? ?? 'Описание недоступно',
                'durability': course['durability'] as String? ?? 'Неизвестно',
                'lessons': [],
              };
            }

            final lessonData = {
              'id': lesson['_id'] as String? ?? '',
              'title': lesson['title'] as String? ?? 'Без названия',
              'link': lesson['link'] as String? ?? '', // Add link to lessonData
            };
            (courses[courseId]!['lessons'] as List).add(lessonData);
          }

          for (var course in courses.values) {
            final courseLessons = course['lessons'] as List<dynamic>;
            final courseData =
                data.firstWhere(
                      (l) => l['course']?['_id'] == course['id'],
                      orElse: () => {},
                    )['course']
                    as Map<String, dynamic>?;

            if (courseData != null && courseData['lessons'] is List) {
              final orderedUrls = courseData['lessons'] as List<dynamic>;
              course['lessons'] =
                  orderedUrls.map((url) {
                    return courseLessons.firstWhere(
                      (lesson) => lesson['link'] == url,
                      orElse: () => {'title': 'Неизвестный урок', 'link': url},
                    );
                  }).toList();
            }
          }

          return courses.values.toList();
        }
        print('Ошибка: Неверный формат данных');
        return null;
      } else {
        print('Ошибка при получении уроков: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.profession,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(color: Colors.grey.shade200),
                    ),
                errorWidget:
                    (context, url, error) =>
                        Container(color: Colors.grey.shade200),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade300.withOpacity(0.7),
                        Colors.white.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'profession-image-${widget.imageUrl}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            height: 200,
                            width: 350,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 200,
                                    width: 300,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 200,
                                  width: 300,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ),
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.deepPurple.shade100.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.profession,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.deepPurple.shade900,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Курсы',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple.shade900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              widget.courses.isEmpty
                                  ? Text(
                                    'Курсы недоступны',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.courses.length,
                                    itemBuilder: (context, index) {
                                      final course = widget.courses[index];
                                      final lessons =
                                          course['lessons'] as List<dynamic>? ??
                                          [];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 15,
                                        ),
                                        child: ExpansionTile(
                                          title: Text(
                                            course['title'] as String? ??
                                                'Без названия',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.deepPurple.shade700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            'Мерзімі: ${course['durability'] ?? 'Неизвестно'}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          onExpansionChanged: (expanded) {
                                            if (!expanded) {
                                              for (var item
                                                  in videoControllers) {
                                                if (item['courseId'] ==
                                                    course['id']) {
                                                  (item['controller']
                                                          as YoutubePlayerController)
                                                      .pause();
                                                }
                                              }
                                            }
                                          },
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    course['description']
                                                            as String? ??
                                                        'Описание недоступно',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Сабақтар (${lessons.length})',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors
                                                              .deepPurple
                                                              .shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  lessons.isEmpty
                                                      ? Text(
                                                        'Уроки недоступны',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors
                                                                      .grey
                                                                      .shade600,
                                                            ),
                                                      )
                                                      : Column(
                                                        children:
                                                            lessons.map((
                                                              lesson,
                                                            ) {
                                                              final lessonId =
                                                                  lesson['id']
                                                                      as String? ??
                                                                  '';
                                                              final controllerItem =
                                                                  videoControllers.firstWhere(
                                                                    (item) =>
                                                                        item['lessonId'] ==
                                                                        lessonId,
                                                                    orElse:
                                                                        () =>
                                                                            {},
                                                                  );
                                                              final controller =
                                                                  controllerItem['controller']
                                                                      as YoutubePlayerController?;
                                                              if (controller ==
                                                                  null) {
                                                                return Container(
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            12,
                                                                      ),
                                                                  child: Text(
                                                                    'Видео недоступно: ${lesson['title']}',
                                                                    style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          Colors
                                                                              .red,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      bottom:
                                                                          12,
                                                                    ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      lesson['title']
                                                                              as String? ??
                                                                          'Без названия',
                                                                      style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color:
                                                                            Colors.grey.shade800,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                              0.1,
                                                                            ),
                                                                            blurRadius:
                                                                                4,
                                                                            offset: const Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child: AspectRatio(
                                                                        aspectRatio:
                                                                            16 /
                                                                            9,
                                                                        child: YoutubePlayer(
                                                                          controller:
                                                                              controller,
                                                                          showVideoProgressIndicator:
                                                                              true,
                                                                          progressIndicatorColor:
                                                                              Colors.deepPurple,
                                                                          progressColors: const ProgressBarColors(
                                                                            playedColor:
                                                                                Colors.deepPurple,
                                                                            handleColor:
                                                                                Colors.deepPurpleAccent,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Оқуды бастау: ${widget.profession}',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        backgroundColor:
                                            Colors.deepPurple.shade300,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade300,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    'Оқуды бастау',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
