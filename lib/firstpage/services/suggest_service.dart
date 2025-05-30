import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://helpai-server.vercel.app/api/professions/';

  Future<List<EngineeringSpecialty>> fetchSpecialties() async {
    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => EngineeringSpecialty.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load specialties: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching specialties: $e');
    }
  }
}

class ApiServiceSingular {
  final Dio _dio = Dio();
  final String baseUrl = 'https://helpai-server.vercel.app/api/professions/';

  Future<List<EngineeringSpecialty>> fetchSpecialties() async {
    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => EngineeringSpecialty.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load specialties: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching specialties: $e');
    }
  }
}

class EngineeringSpecialty {
  final String id;
  final String name;
  final List<String> roadmap;
  final List<Course> course;

  EngineeringSpecialty({
    required this.id,
    required this.name,
    required this.roadmap,
    required this.course,
  });

  factory EngineeringSpecialty.fromJson(Map<String, dynamic> json) {
    return EngineeringSpecialty(
      id: json['_id'],
      name: json['name'],
      roadmap: List<String>.from(json['roadmap']),
      course:
          (json['course'] as List)
              .map((courseJson) => Course.fromJson(courseJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'roadmap': roadmap,
    'course': course.map((c) => c.toJson()).toList(),
  };
}

class Course {
  final String id;
  final String title;
  final String description;
  final String durability;
  final List<String> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.durability,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      durability: json['durability'],
      lessons: List<String>.from(json['lessons']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'description': description,
    'durability': durability,
    'lessons': lessons,
  };
}
