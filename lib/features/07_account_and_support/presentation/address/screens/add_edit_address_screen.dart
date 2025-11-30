import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_textfield.dart';

// Domain Imports
import '../../../../05_checkout/domain/entities/order.dart';

class AddEditAddressScreen extends StatefulWidget {
  // اگر یہ null ہو تو ہم نیا ایڈریس بنا رہے ہیں، ورنہ ایڈٹ کر رہے ہیں
  final OrderAddress? addressToEdit;

  const AddEditAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _addressController;
  late TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    final address = widget.addressToEdit;

    // اگر ایڈٹ کر رہے ہیں تو ڈیٹا بھر دیں، ورنہ خالی رکھیں
    _firstNameController = TextEditingController(text: address?.firstName ?? '');
    _lastNameController = TextEditingController(text: address?.lastName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _emailController = TextEditingController(text: address?.email ?? '');
    _countryController = TextEditingController(text: address?.country ?? 'Saudi Arabia');
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateController = TextEditingController(text: address?.state ?? '');
    _addressController = TextEditingController(text: address?.address1 ?? '');
    _zipController = TextEditingController(text: address?.postcode ?? '');
  }

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

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API/DB Delay
    await Future.delayed(const Duration(seconds: 1));

    // ایڈریس آبجیکٹ بنائیں
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

      // پچھلی اسکرین کو ڈیٹا واپس بھیجیں
      context.pop(newAddress);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.addressToEdit == null
              ? "Address added successfully"
              : "Address updated successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressToEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? "Edit Address" : "Add New Address"),
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
                        readOnly: true, // فی الحال فکسڈ
                        suffixIcon: const Icon(Icons.arrow_drop_down),
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
                  text: isEditing ? "Update Address" : "Save Address",
                  isLoading: _isLoading,
                  onPressed: _onSave,
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