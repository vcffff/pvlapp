class oneStep {
  final String? title;
  final int? id;
  final List<subStep> subSteps = [];
  oneStep({required this.title, required this.id, required subSteps});
  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'subSteps': subSteps,
  };

  factory oneStep.fromJson(Map<String, dynamic> json) =>
      oneStep(title: json['title'], id: json['id'], subSteps: json['subSteps']);
}

class subStep {
  final String? title;
  final int? id;
  subStep({required this.title, required this.id});
  Map<String, dynamic> toJson() => {'title': title, 'id': id};

  factory subStep.fromJson(Map<String, dynamic> json) =>
      subStep(title: json['title'], id: json['id']);
}
