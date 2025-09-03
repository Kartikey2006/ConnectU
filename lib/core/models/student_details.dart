class StudentDetails {
  final int userId;
  final int currentYear;
  final String branch;
  final List<String> skills;
  final String? university;
  final String? major;
  final double? gpa;

  const StudentDetails({
    required this.userId,
    required this.currentYear,
    required this.branch,
    required this.skills,
    this.university,
    this.major,
    this.gpa,
  });

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
      userId: json['user_id'] as int,
      currentYear: json['current_year'] as int,
      branch: json['branch'] as String,
      skills: List<String>.from(json['skills'] ?? []),
      university: json['university'] as String?,
      major: json['major'] as String?,
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_year': currentYear,
      'branch': branch,
      'skills': skills,
      'university': university,
      'major': major,
      'gpa': gpa,
    };
  }

  StudentDetails copyWith({
    int? userId,
    int? currentYear,
    String? branch,
    List<String>? skills,
    String? university,
    String? major,
    double? gpa,
  }) {
    return StudentDetails(
      userId: userId ?? this.userId,
      currentYear: currentYear ?? this.currentYear,
      branch: branch ?? this.branch,
      skills: skills ?? this.skills,
      university: university ?? this.university,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentDetails && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'StudentDetails(userId: $userId, currentYear: $currentYear, branch: $branch, skills: $skills)';
  }
}
