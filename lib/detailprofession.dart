import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось открыть ссылку: $url'),
          backgroundColor: Colors.red,
        ),
      );
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
                              const SizedBox(height: 10),

                              const SizedBox(height: 10),
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
                                            'Продолжительность: ${course['durability'] ?? 'Неизвестно'}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
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
                                                    'Уроки (${lessons.length})',
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
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  final link =
                                                                      lesson['link']
                                                                          as String?;
                                                                  if (link !=
                                                                      null) {
                                                                    _launchUrl(
                                                                      link,
                                                                    );
                                                                  }
                                                                },
                                                                child: Container(
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            8,
                                                                      ),
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        10,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                              0.1,
                                                                            ),
                                                                        blurRadius:
                                                                            4,
                                                                        offset:
                                                                            const Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .play_circle_outline,
                                                                        color:
                                                                            Colors.deepPurple.shade300,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          lesson['content']
                                                                                  as String? ??
                                                                              'Без названия',
                                                                          style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey.shade800,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
