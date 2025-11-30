import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // فون/ای میل کھولنے کے لیے

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_textfield.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  // FAQs Data
  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I track my order?",
      "answer": "You can track your order by going to 'My Orders' in your account section and selecting the order you wish to track."
    },
    {
      "question": "What is the return policy?",
      "answer": "We offer a 14-day return policy for all unused items in their original packaging. Please visit our Returns page for more details."
    },
    {
      "question": "Do you ship internationally?",
      "answer": "Yes, we ship to select countries. Shipping costs will apply, and will be added at checkout."
    },
    {
      "question": "How can I change my payment method?",
      "answer": "You can manage your payment methods in the 'My Account' > 'Wallet & Payment' section."
    },
  ];

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch action")),
        );
      }
    }
  }

  void _showContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Send us a message", style: AppTypography.textTheme.titleMedium),
            const SizedBox(height: 16),
            const CustomTextField(
              hintText: "Subject",
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              hintText: "Describe your issue...",
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Submit Ticket",
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ticket submitted successfully. We'll contact you soon."),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Customer Support"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Contact Cards Grid
            Text("Contact Us", style: AppTypography.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.chat_bubble_outline,
                    title: "Live Chat",
                    subtitle: "Average wait: 2 mins",
                    color: Colors.blue.shade50,
                    iconColor: Colors.blue,
                    onTap: () {
                      // Open Chat Screen (Future Feature) or WhatsApp
                      // _launchUrl("https://wa.me/1234567890");
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.email_outlined,
                    title: "Email Us",
                    subtitle: "Reply within 24 hrs",
                    color: Colors.orange.shade50,
                    iconColor: Colors.orange,
                    onTap: () => _launchUrl("mailto:support@goshary.com"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: "Call Us",
              subtitle: "+966 12 345 6789 (9 AM - 6 PM)",
              color: Colors.green.shade50,
              iconColor: Colors.green,
              onTap: () => _launchUrl("tel:+966123456789"),
            ),

            const SizedBox(height: 30),

            // 2. Submit Ticket Button
            CustomButton(
              text: "Submit a Query",
              isOutlined: true,
              onPressed: () => _showContactForm(context),
            ),

            const SizedBox(height: 30),

            // 3. FAQs Section
            Text("Frequently Asked Questions", style: AppTypography.textTheme.titleMedium),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        _faqs[index]['question']!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        Text(
                          _faqs[index]['answer']!,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}