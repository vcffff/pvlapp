import 'package:dio/dio.dart';

Future<Map<String, dynamic>?> getCourseDataById(String courseId) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      'https://helpai-server.vercel.app/api/professions/$courseId',
    );
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final courseList = data['course'] as List<dynamic>?;
        return {
          'name': data['name'] as String?,
          'description':
              courseList?.isNotEmpty == true
                  ? courseList![0]['description'] as String?
                  : null,
          'durability':
              courseList?.isNotEmpty == true
                  ? courseList![0]['durability'] as String?
                  : null,
          'lessons':
              courseList?.isNotEmpty == true
                  ? (courseList![0]['lessons'] as List<dynamic>?)?.length ?? 0
                  : 0,
        };
      }
      print('Ошибка: Неверный формат данных');
      return null;
    } else {
      print('Ошибка при получении курса: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Ошибка: $e');
    return null;
  }
}

Future<String?> getCourseTitleById(String userId, String courseId) async {
  final Dio dio = Dio();
  try {
    final response = await dio.get(
      'https://helpai-server.vercel.app/api/professions/$courseId',
    );
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('name')) {
        return data['name'] as String?;
      } else {
        print('Ошибка: нет поля name в ответе');
        return null;
      }
    } else {
      print('Ошибка при получении курса: ${response.statusCode}');
      return null;
    }
  } on DioException catch (e) {
    print('Сетевая ошибка: ${e.message}');
    return null;
  } catch (e) {
    print('Неизвестная ошибка: $e');
    return null;
  }
}


Future<List<Map<String, dynamic>>?> getCoursesByProfessionId(String professionId) async {
  try {
    final dio = Dio();
    final response = await dio.get('https://helpai-server.vercel.app/api/courses?professionId=$professionId');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List<dynamic>) {
        return data.map((course) {
          return {
            'id': course['_id'] as String?,
            'title': course['title'] as String?,
            'description': course['description'] as String?,
            'durability': course['durability'] as String?,
            'lessons': (course['lessons'] as List<dynamic>?)?.map((lessonId) {
              final lesson = course['lessonsData']?.firstWhere(
                (l) => l['_id'] == lessonId,
                orElse: () => null,
              );
              return {
                'id': lesson?['_id'] as String?,
                'title': lesson?['title'] as String?,
                'link': lesson?['link'] as String?,
              };
            }).toList() ?? [],
          };
        }).toList();
      }
      print('Ошибка: Неверный формат данных курсов');
      return null;
    } else {
      print('Ошибка при получении курсов: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Ошибка: $e');
    return null;
  }
}