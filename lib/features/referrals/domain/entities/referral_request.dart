import 'student_profile.dart';

enum ReferralRequestStatus {
  pending,
  guidanceOffered,
  closed,
}

class ReferralRequest {
  final int id;
  final StudentProfile student;
  final int alumniId;
  final String? company;
  final String? position;
  final String? message;
  final ReferralRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? responseMessage;

  const ReferralRequest({
    required this.id,
    required this.student,
    required this.alumniId,
    this.company,
    this.position,
    this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.responseMessage,
  });

  factory ReferralRequest.fromJson(Map<String, dynamic> json) {
    return ReferralRequest(
      id: json['id'] as int,
      student: StudentProfile.fromJson(json['student'] as Map<String, dynamic>),
      alumniId: json['alumni_id'] as int,
      company: json['company'] as String?,
      position: json['position'] as String?,
      message: json['message'] as String?,
      status: ReferralRequestStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ReferralRequestStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      responseMessage: json['response_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student.toJson(),
      'alumni_id': alumniId,
      'company': company,
      'position': position,
      'message': message,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'response_message': responseMessage,
    };
  }

  ReferralRequest copyWith({
    int? id,
    StudentProfile? student,
    int? alumniId,
    String? company,
    String? position,
    String? message,
    ReferralRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? responseMessage,
  }) {
    return ReferralRequest(
      id: id ?? this.id,
      student: student ?? this.student,
      alumniId: alumniId ?? this.alumniId,
      company: company ?? this.company,
      position: position ?? this.position,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case ReferralRequestStatus.pending:
        return 'Pending';
      case ReferralRequestStatus.guidanceOffered:
        return 'Guidance Offered';
      case ReferralRequestStatus.closed:
        return 'Closed';
    }
  }

  bool get isActive => status == ReferralRequestStatus.pending;
  bool get isCompleted => status != ReferralRequestStatus.pending;
}
