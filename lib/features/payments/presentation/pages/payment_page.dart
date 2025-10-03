import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/payments/data/models/payment_models.dart';
import 'package:connectu_alumni_platform/features/payments/data/services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  final PaymentRequest paymentRequest;

  const PaymentPage({
    super.key,
    required this.paymentRequest,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentService _paymentService = PaymentService();
  PaymentMethod? _selectedPaymentMethod;
  bool _isProcessing = false;
  String? _upiId;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = _paymentService.getPaymentMethods().first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: NavigationUtils.safeBackButton(
          context: context,
          iconColor: const Color(0xFF0E141B),
          iconSize: 24,
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary Card
            _buildPaymentSummaryCard(),
            const SizedBox(height: 24),

            // Payment Method Selection
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),

            // UPI ID Input (if UPI selected)
            if (_selectedPaymentMethod?.id == 'upi') ...[
              _buildUpiIdInput(),
              const SizedBox(height: 24),
            ],

            // Payment Button
            _buildPaymentButton(),
            const SizedBox(height: 24),

            // Security Notice
            _buildSecurityNotice(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payment,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.paymentRequest.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPaymentTypeText(widget.paymentRequest.type),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4E7097),
                ),
              ),
              Text(
                '₹${widget.paymentRequest.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Processing Fee',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4E7097),
                ),
              ),
              Text(
                '₹${(widget.paymentRequest.amount * 0.02).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4E7097),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
              Text(
                '₹${(widget.paymentRequest.amount * 1.02).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    final paymentMethods = _paymentService.getPaymentMethods();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E141B),
          ),
        ),
        const SizedBox(height: 16),
        ...paymentMethods.map((method) => _buildPaymentMethodCard(method)),
      ],
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    final isSelected = _selectedPaymentMethod?.id == method.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF1979E6) : const Color(0xFFE7EDF3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1979E6).withOpacity(0.1)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  method.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: const Color(0xFF0E141B),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF1979E6),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiIdInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter UPI ID',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E141B),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => _upiId = value,
            decoration: const InputDecoration(
              hintText: 'yourname@upi',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_wallet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Processing...'),
                ],
              )
            : const Text(
                'Pay Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.security,
            color: Color(0xFF10B981),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your payment is secure and encrypted. We do not store your payment details.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF4E7097),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentTypeText(PaymentType type) {
    switch (type) {
      case PaymentType.donation:
        return 'Donation';
      case PaymentType.webinar:
        return 'Webinar Registration';
      case PaymentType.mentorship:
        return 'Mentorship Session';
      case PaymentType.referral:
        return 'Referral Fee';
      case PaymentType.platformFee:
        return 'Platform Fee';
    }
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == null) {
      _showSnackBar('Please select a payment method', isError: true);
      return;
    }

    if (_selectedPaymentMethod!.id == 'upi' &&
        (_upiId == null || _upiId!.isEmpty)) {
      _showSnackBar('Please enter your UPI ID', isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _paymentService.processPayment(
        request: widget.paymentRequest,
        paymentMethodId: _selectedPaymentMethod!.id,
      );

      setState(() {
        _isProcessing = false;
      });

      if (result.status == PaymentStatus.success) {
        _showPaymentSuccessDialog(result);
      } else {
        _showSnackBar(result.message ?? 'Payment failed', isError: true);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showSnackBar('Payment failed. Please try again.', isError: true);
    }
  }

  void _showPaymentSuccessDialog(PaymentResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E141B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Transaction ID: ${result.transactionId}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4E7097),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true); // Return success
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
