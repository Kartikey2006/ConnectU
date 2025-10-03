import 'dart:math';
import 'package:connectu_alumni_platform/features/payments/data/models/payment_models.dart';

// Dummy payment service for demonstration purposes
class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Mock payment methods
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'upi',
      name: 'UPI',
      icon: '💳',
      isEnabled: true,
    ),
    PaymentMethod(
      id: 'card',
      name: 'Credit/Debit Card',
      icon: '💳',
      isEnabled: true,
    ),
    PaymentMethod(
      id: 'netbanking',
      name: 'Net Banking',
      icon: '🏦',
      isEnabled: true,
    ),
    PaymentMethod(
      id: 'wallet',
      name: 'Digital Wallet',
      icon: '📱',
      isEnabled: true,
    ),
  ];

  // Mock donation campaigns
  final List<DonationCampaign> _donationCampaigns = [
    DonationCampaign(
      id: '1',
      title: 'Computer Science Scholarship Fund',
      description: 'Support deserving students in Computer Science program',
      targetAmount: 500000,
      currentAmount: 275000,
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Education',
      endDate: DateTime.now().add(const Duration(days: 30)),
    ),
    DonationCampaign(
      id: '2',
      title: 'Emergency Student Support',
      description: 'Help students facing financial difficulties',
      targetAmount: 200000,
      currentAmount: 125000,
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Emergency',
      endDate: DateTime.now().add(const Duration(days: 15)),
    ),
    DonationCampaign(
      id: '3',
      title: 'Library Modernization',
      description: 'Upgrade library facilities and digital resources',
      targetAmount: 1000000,
      currentAmount: 450000,
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Infrastructure',
      endDate: DateTime.now().add(const Duration(days: 60)),
    ),
  ];

  // Get available payment methods
  List<PaymentMethod> getPaymentMethods() {
    return List.from(_paymentMethods);
  }

  // Get donation campaigns
  List<DonationCampaign> getDonationCampaigns() {
    return List.from(_donationCampaigns);
  }

  // Get specific donation campaign
  DonationCampaign? getDonationCampaign(String id) {
    try {
      return _donationCampaigns.firstWhere((campaign) => campaign.id == id);
    } catch (e) {
      return null;
    }
  }

  // Process payment (dummy implementation)
  Future<PaymentResult> processPayment({
    required PaymentRequest request,
    required String paymentMethodId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate random success/failure (90% success rate)
    final random = Random();
    final isSuccess = random.nextDouble() > 0.1;

    final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

    if (isSuccess) {
      return PaymentResult(
        transactionId: transactionId,
        status: PaymentStatus.success,
        message: 'Payment successful!',
        timestamp: DateTime.now(),
        metadata: {
          'payment_method': paymentMethodId,
          'amount': request.amount,
          'currency': request.currency,
        },
      );
    } else {
      return PaymentResult(
        transactionId: transactionId,
        status: PaymentStatus.failed,
        message: 'Payment failed. Please try again.',
        timestamp: DateTime.now(),
        metadata: {
          'payment_method': paymentMethodId,
          'amount': request.amount,
          'currency': request.currency,
        },
      );
    }
  }

  // Get payment history (dummy data)
  Future<List<PaymentResult>> getPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PaymentResult(
        transactionId: 'TXN_001',
        status: PaymentStatus.success,
        message: 'Donation to Computer Science Scholarship Fund',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        metadata: {'amount': 5000, 'type': 'donation'},
      ),
      PaymentResult(
        transactionId: 'TXN_002',
        status: PaymentStatus.success,
        message: 'Webinar registration fee',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        metadata: {'amount': 500, 'type': 'webinar'},
      ),
      PaymentResult(
        transactionId: 'TXN_003',
        status: PaymentStatus.success,
        message: 'Mentorship session payment',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        metadata: {'amount': 1000, 'type': 'mentorship'},
      ),
    ];
  }

  // Create payment request
  PaymentRequest createPaymentRequest({
    required double amount,
    required String description,
    required PaymentType type,
    String? referenceId,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentRequest(
      id: 'REQ_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      description: description,
      type: type,
      referenceId: referenceId,
      metadata: metadata ?? {},
    );
  }

  // Simulate payment gateway initialization
  Future<bool> initializePaymentGateway() async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Always successful for dummy
  }

  // Get payment statistics
  Map<String, dynamic> getPaymentStats() {
    return {
      'total_donations': 15750.0,
      'total_webinars': 1250.0,
      'total_mentorship': 3200.0,
      'total_referrals': 500.0,
      'monthly_goal': 25000.0,
      'monthly_progress': 0.75,
    };
  }
}
