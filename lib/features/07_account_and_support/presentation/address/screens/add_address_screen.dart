import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

// Domain Imports (تاکہ ہم Address Object واپس بھیج سکیں)
import '../../../05_checkout/domain/entities/order.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController(text: "Saudi Arabia"); // Default
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _onSaveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock API Call Simulation
    await Future.delayed(const Duration(seconds: 1));

    // 1. ایڈریس آبجیکٹ بنائیں
    final newAddress = OrderAddress(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      address1: _addressController.text.trim(),
      postcode: _zipController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);

      // 2. پچھلی اسکرین (Checkout) کو یہ ایڈریس واپس بھیجیں
      context.pop(newAddress);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Address saved successfully"),
            backgroundColor: AppColors.success
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),

                // First & Last Name
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "First Name",
                        controller: _firstNameController,
                        validator: (val) => AppValidators.validateRequired(val, 'First Name'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: "Last Name",
                        controller: _lastNameController,
                        validator: (val) => AppValidators.validateRequired(val, 'Last Name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  hintText: "Email Address",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: AppValidators.validateEmail,
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextField(
                  hintText: "Phone Number",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: AppValidators.validatePhone,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                const Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),

                // Country & City
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "Country",
                        controller: _countryController,
                        readOnly: true, // فی الحال فکسڈ ہے
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        onTap: () {
                          // Show Country Picker
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: "City",
                        controller: _cityController,
                        validator: (val) => AppValidators.validateRequired(val, 'City'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // State & Zip
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "State / Province",
                        controller: _stateController,
                        validator: (val) => AppValidators.validateRequired(val, 'State'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: "Zip Code",
                        controller: _zipController,
                        keyboardType: TextInputType.number,
                        validator: (val) => AppValidators.validateRequired(val, 'Zip Code'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Full Address
                CustomTextField(
                  hintText: "Address (Street, Apt, Suite)",
                  controller: _addressController,
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (val) => AppValidators.validateRequired(val, 'Address'),
                ),

                const SizedBox(height: 40),

                // Save Button
                CustomButton(
                  text: "Save Address",
                  isLoading: _isLoading,
                  onPressed: _onSaveAddress,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}