class Challenge {
  int? id;
  String title;
  String category;
  int targetUnits;
  String description;

  Challenge({
    this.id,
    required this.title,
    required this.category,
    required this.targetUnits,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'targetUnits': targetUnits,
      'description': description,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      targetUnits: map['targetUnits'],
      description: map['description'],
    );
  }
}
