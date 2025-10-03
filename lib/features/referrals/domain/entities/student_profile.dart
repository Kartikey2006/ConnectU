class StudentProfile {
  final int id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final String? phoneNumber;
  final String? resumeUrl;
  final EducationDetails? education;
  final List<String> skills;
  final List<Project> projects;
  final List<WorkExperience> workExperience;
  final String? personalNote;
  final DateTime createdAt;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.phoneNumber,
    this.resumeUrl,
    this.education,
    this.skills = const [],
    this.projects = const [],
    this.workExperience = const [],
    this.personalNote,
    required this.createdAt,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phone_number'] as String?,
      resumeUrl: json['resume_url'] as String?,
      education: json['education'] != null
          ? EducationDetails.fromJson(json['education'] as Map<String, dynamic>)
          : null,
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((p) => Project.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      workExperience: (json['work_experience'] as List<dynamic>?)
              ?.map((w) => WorkExperience.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
      personalNote: json['personal_note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'phone_number': phoneNumber,
      'resume_url': resumeUrl,
      'education': education?.toJson(),
      'skills': skills,
      'projects': projects.map((p) => p.toJson()).toList(),
      'work_experience': workExperience.map((w) => w.toJson()).toList(),
      'personal_note': personalNote,
      'created_at': createdAt.toIso8601String(),
    };
  }

  StudentProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    String? phoneNumber,
    String? resumeUrl,
    EducationDetails? education,
    List<String>? skills,
    List<Project>? projects,
    List<WorkExperience>? workExperience,
    String? personalNote,
    DateTime? createdAt,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      workExperience: workExperience ?? this.workExperience,
      personalNote: personalNote ?? this.personalNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EducationDetails {
  final String university;
  final String degree;
  final String fieldOfStudy;
  final String graduationYear;
  final double? gpa;
  final List<String>? relevantCoursework;

  const EducationDetails({
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.gpa,
    this.relevantCoursework,
  });

  factory EducationDetails.fromJson(Map<String, dynamic> json) {
    return EducationDetails(
      university: json['university'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      graduationYear: json['graduation_year'] as String,
      gpa: json['gpa'] as double?,
      relevantCoursework:
          (json['relevant_coursework'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'university': university,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'graduation_year': graduationYear,
      'gpa': gpa,
      'relevant_coursework': relevantCoursework,
    };
  }
}

class Project {
  final String name;
  final String description;
  final String? technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String? duration;

  const Project({
    required this.name,
    required this.description,
    this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.duration,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: json['technologies'] as String?,
      githubUrl: json['github_url'] as String?,
      liveUrl: json['live_url'] as String?,
      duration: json['duration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'github_url': githubUrl,
      'live_url': liveUrl,
      'duration': duration,
    };
  }
}

class WorkExperience {
  final String company;
  final String position;
  final String duration;
  final String? description;
  final List<String>? responsibilities;

  const WorkExperience({
    required this.company,
    required this.position,
    required this.duration,
    this.description,
    this.responsibilities,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      company: json['company'] as String,
      position: json['position'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String?,
      responsibilities:
          (json['responsibilities'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'duration': duration,
      'description': description,
      'responsibilities': responsibilities,
    };
  }
}
