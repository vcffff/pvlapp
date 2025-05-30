import 'package:dio/dio.dart';

class AuthResponse {
  final String id;
  final String name;
  final String role;
  final String refreshToken;
  final String? telegramId;
  final List<String> tests;
  final List<String> professions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthResponse({
    required this.id,
    required this.name,
    required this.role,
    required this.refreshToken,
    this.telegramId,
    this.tests = const [],
    this.professions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      telegramId: json['telegram_id']?.toString(),
      tests: json['tests'] != null ? List<String>.from(json['tests']) : [],
      professions:
          json['professions'] != null
              ? List<String>.from(json['professions'])
              : [],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }
  static Future<AuthResponse?> login(String name, String password) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://helpai-server.vercel.app/api/auth',
        data: {'name': name, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['foundUser'] != null) {
        return AuthResponse.fromJson(response.data['foundUser']);
      } else {
        print('Login failed: Invalid response structure');
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        print('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
        if (e.response?.statusCode == 404) {
          print('User not found. Check the name or register a new user.');
        } else if (e.response?.statusCode == 403) {
          print('Incorrect password.');
        }
      } else {
        print('Unexpected error: $e');
      }
      return null;
    }
  }
}

void main() async {
  final professions = await fetchProfessions("Jane", "1234");
  print(professions);
}

Future<List<String>?> fetchProfessions(String name, String password) async {
  try {
    final dio = Dio();
    final response = await dio.post(
      'https://helpai-server.vercel.app/api/auth',
      data: {'name': name, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final professions = List<String>.from(data['foundUser']['professions']);
      print('Профессии успешно получены: $professions');
      return professions;
    } else {
      print('Ошибка: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Ошибка при запросе: $e');
    return null;
  }
}
