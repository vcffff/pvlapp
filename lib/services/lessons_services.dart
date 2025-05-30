import 'package:dio/dio.dart';

Future<List<Map<String, dynamic>>?> getLessonsByCourseId(String courseId) async {
  try {
    final dio = Dio();
    final response = await dio.get('https://helpai-server.vercel.app/api/lessons?courseId=$courseId');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List<dynamic>) {
        return data.map((lesson) => {
          'id': lesson['_id'] as String?,
          'title': lesson['title'] as String?,
          'link': lesson['link'] as String?,
        }).toList();
      }
      print('Ошибка: Неверный формат данных уроков');
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