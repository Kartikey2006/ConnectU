import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/payments/data/models/payment_models.dart';
import 'package:connectu_alumni_platform/features/payments/data/services/payment_service.dart';
import 'package:connectu_alumni_platform/features/payments/presentation/pages/payment_page.dart';

class DonationCampaignsPage extends StatefulWidget {
  const DonationCampaignsPage({super.key});

  @override
  State<DonationCampaignsPage> createState() => _DonationCampaignsPageState();
}

class _DonationCampaignsPageState extends State<DonationCampaignsPage> {
  final PaymentService _paymentService = PaymentService();
  List<DonationCampaign> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _campaigns = _paymentService.getDonationCampaigns();
      _isLoading = false;
    });
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
          'Donation Campaigns',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showStats,
            icon: const Icon(
              Icons.analytics,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Stats
                  _buildHeaderStats(),
                  const SizedBox(height: 24),

                  // Campaigns List
                  const Text(
                    'Active Campaigns',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E141B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._campaigns.map((campaign) => _buildCampaignCard(campaign)),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderStats() {
    final stats = _paymentService.getPaymentStats();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1979E6), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1979E6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fundraising Impact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Raised',
                  '₹${(stats['total_donations'] as double).toStringAsFixed(0)}',
                  Icons.attach_money,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Campaigns',
                  '${_campaigns.length}',
                  Icons.campaign,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'This Month',
                  '₹${((stats['total_donations'] as double) * 0.3).toStringAsFixed(0)}',
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Goal Progress',
                  '${((stats['monthly_progress'] as double) * 100).toStringAsFixed(0)}%',
                  Icons.flag,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignCard(DonationCampaign campaign) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Campaign Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(campaign.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Category Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      campaign.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Progress Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: campaign.progressPercentage / 100,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Campaign Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  campaign.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E7097),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress Stats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${campaign.currentAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          Text(
                            'raised of ₹${campaign.targetAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4E7097),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${campaign.progressPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E141B),
                          ),
                        ),
                        const Text(
                          'funded',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4E7097),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Days Left
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: Color(0xFF4E7097),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${campaign.endDate.difference(DateTime.now()).inDays} days left',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Donate Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _donateToCampaign(campaign),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Donate Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _donateToCampaign(DonationCampaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDonationBottomSheet(campaign),
    );
  }

  Widget _buildDonationBottomSheet(DonationCampaign campaign) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE7EDF3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Donate to ${campaign.title}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 20),
                _buildQuickAmountButtons(campaign),
                const SizedBox(height: 20),
                _buildCustomAmountField(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _proceedToPayment(campaign, 1000); // Default amount
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continue to Payment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButtons(DonationCampaign campaign) {
    final amounts = [500, 1000, 2500, 5000, 10000];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Amounts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E141B),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _proceedToPayment(campaign, amount.toDouble());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE7EDF3)),
                ),
                child: Text(
                  '₹$amount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E141B),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomAmountField() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E141B),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void _proceedToPayment(DonationCampaign campaign, double amount) {
    final paymentRequest = _paymentService.createPaymentRequest(
      amount: amount,
      description: 'Donation to ${campaign.title}',
      type: PaymentType.donation,
      referenceId: campaign.id,
      metadata: {
        'campaign_id': campaign.id,
        'campaign_title': campaign.title,
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(paymentRequest: paymentRequest),
      ),
    ).then((success) {
      if (success == true) {
        _showSnackBar('Thank you for your donation!', isError: false);
        _loadCampaigns(); // Refresh campaigns
      }
    });
  }

  void _showStats() {
    final stats = _paymentService.getPaymentStats();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fundraising Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Total Donations',
                '₹${(stats['total_donations'] as double).toStringAsFixed(0)}'),
            _buildStatRow('Webinar Revenue',
                '₹${(stats['total_webinars'] as double).toStringAsFixed(0)}'),
            _buildStatRow('Mentorship Revenue',
                '₹${(stats['total_mentorship'] as double).toStringAsFixed(0)}'),
            _buildStatRow('Referral Revenue',
                '₹${(stats['total_referrals'] as double).toStringAsFixed(0)}'),
            const Divider(),
            _buildStatRow('Monthly Goal',
                '₹${(stats['monthly_goal'] as double).toStringAsFixed(0)}'),
            _buildStatRow('Monthly Progress',
                '${((stats['monthly_progress'] as double) * 100).toStringAsFixed(0)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
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
