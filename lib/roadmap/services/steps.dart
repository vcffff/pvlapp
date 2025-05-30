class oneStep {
  final String? title;
  final int? id;
  final List<subStep> subSteps;
  String status;
  oneStep({
    required this.title,
    required this.id,
    required this.subSteps,
    required this.status,
  });
  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'subSteps': subSteps,
    'status': status,
  };

  factory oneStep.fromJson(Map<String, dynamic> json) => oneStep(
    title: json['title'],
    id: json['id'],
    subSteps: json['subSteps'],
    status: json['status'],
  );
}

class subStep {
  final String? title;
  final int? id;
  bool status;
  subStep({required this.title, required this.id, required this.status});
  Map<String, dynamic> toJson() => {'title': title, 'id': id, 'status': status};

  factory subStep.fromJson(Map<String, dynamic> json) =>
      subStep(title: json['title'], id: json['id'], status: json['status']);
}
