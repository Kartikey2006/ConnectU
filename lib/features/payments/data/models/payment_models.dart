// Payment models for dummy/mock payment system
class PaymentRequest {
  final String id;
  final double amount;
  final String currency;
  final String description;
  final PaymentType type;
  final String? referenceId; // For donations, webinar bookings, etc.
  final Map<String, dynamic> metadata;

  PaymentRequest({
    required this.id,
    required this.amount,
    this.currency = 'INR',
    required this.description,
    required this.type,
    this.referenceId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'currency': currency,
    'description': description,
    'type': type.name,
    'reference_id': referenceId,
    'metadata': metadata,
  };
}

enum PaymentType {
  donation,
  webinar,
  mentorship,
  referral,
  platformFee,
}

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final bool isEnabled;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    this.isEnabled = true,
  });
}

class PaymentResult {
  final String transactionId;
  final PaymentStatus status;
  final String? message;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PaymentResult({
    required this.transactionId,
    required this.status,
    this.message,
    required this.timestamp,
    this.metadata,
  });
}

enum PaymentStatus {
  pending,
  success,
  failed,
  cancelled,
  refunded,
}

class DonationCampaign {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final String imageUrl;
  final String category;
  final bool isActive;
  final DateTime endDate;

  DonationCampaign({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.imageUrl,
    required this.category,
    this.isActive = true,
    required this.endDate,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
}
