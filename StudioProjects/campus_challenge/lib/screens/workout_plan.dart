class WorkoutPlan {
  int? id;
  String name;
  String description;
  String goal;
  String createdAt;

  WorkoutPlan({
    this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'goal': goal,
      'createdAt': createdAt,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      goal: map['goal'],
      createdAt: map['createdAt'],
    );
  }
}