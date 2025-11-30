import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/navigation/route_names.dart';
import '../../../../../core/widgets/custom_button.dart';

// Domain Imports
import '../../../../05_checkout/domain/entities/order.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  // Mock Data (اصلی ایپ میں یہ API یا Local DB سے آئے گا)
  final List<OrderAddress> _addresses = [
    OrderAddress(
      firstName: "Sarah",
      lastName: "Anderson",
      address1: "123 Fashion Street, Apt 4B",
      city: "Jeddah",
      state: "Makkah",
      postcode: "21442",
      country: "Saudi Arabia",
      email: "sarah@example.com",
      phone: "+966 50 123 4567",
    ),
    OrderAddress(
      firstName: "Sarah",
      lastName: "Work",
      address1: "King Road Tower, Office 402",
      city: "Riyadh",
      state: "Riyadh",
      postcode: "11564",
      country: "Saudi Arabia",
      email: "sarah.work@example.com",
      phone: "+966 55 987 6543",
    ),
  ];

  // نیا ایڈریس شامل کرنے کا فنکشن
  void _addNewAddress() async {
    // Add Address Screen پر جائیں اور نتیجے کا انتظار کریں
    final result = await context.pushNamed(RouteNames.addAddress);

    // اگر یوزر نے نیا ایڈریس سیو کیا ہے
    if (result != null && result is OrderAddress) {
      setState(() {
        _addresses.add(result);
      });
    }
  }

  // ایڈریس ڈیلیٹ کرنے کا فنکشن
  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("My Addresses"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _addresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildAddressCard(index, _addresses[index]);
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SafeArea(
          child: CustomButton(
            text: "Add New Address",
            onPressed: _addNewAddress,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(int index, OrderAddress address) {
    final isDefault = index == 0; // فرض کریں پہلا ایڈریس ڈیفالٹ ہے

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDefault ? Border.all(color: AppColors.primary, width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isDefault ? "Default Address" : "Address ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              // Actions Menu (Edit/Delete)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') _deleteAddress(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text("Delete", style: TextStyle(color: AppColors.error)),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            "${address.firstName} ${address.lastName}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            address.address1,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            "${address.city}, ${address.state} ${address.postcode}",
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            address.country,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                address.phone,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "No Addresses Saved",
            style: AppTypography.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            "Add a shipping address to speed up checkout.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}