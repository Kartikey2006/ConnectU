class AlumniDetails {
  final int userId;
  final int batchYear;
  final String? company;
  final String? designation;
  final String? linkedinUrl;
  final bool verificationStatus;
  final String? industry;
  final String? experience;
  final List<String>? expertise;

  const AlumniDetails({
    required this.userId,
    required this.batchYear,
    this.company,
    this.designation,
    this.linkedinUrl,
    required this.verificationStatus,
    this.industry,
    this.experience,
    this.expertise,
  });

  factory AlumniDetails.fromJson(Map<String, dynamic> json) {
    return AlumniDetails(
      userId: json['user_id'] as int,
      batchYear: json['batch_year'] as int,
      company: json['company'] as String?,
      designation: json['designation'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      verificationStatus: json['verification_status'] as bool,
      industry: json['industry'] as String?,
      experience: json['experience'] as String?,
      expertise: json['expertise'] != null 
          ? List<String>.from(json['expertise']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'batch_year': batchYear,
      'company': company,
      'designation': designation,
      'linkedin_url': linkedinUrl,
      'verification_status': verificationStatus,
      'industry': industry,
      'experience': experience,
      'expertise': expertise,
    };
  }

  AlumniDetails copyWith({
    int? userId,
    int? batchYear,
    String? company,
    String? designation,
    String? linkedinUrl,
    bool? verificationStatus,
    String? industry,
    String? experience,
    List<String>? expertise,
  }) {
    return AlumniDetails(
      userId: userId ?? this.userId,
      batchYear: batchYear ?? this.batchYear,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      industry: industry ?? this.industry,
      experience: experience ?? this.experience,
      expertise: expertise ?? this.expertise,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlumniDetails && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'AlumniDetails(userId: $userId, batchYear: $batchYear, company: $company, designation: $designation)';
  }
}
