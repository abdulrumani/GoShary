import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

// Feature Imports
import '../../domain/usecases/signup_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/social_login_buttons.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers [cite: 33-41]
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // API کے لیے ضروری ہے
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false; // [cite: 42]

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Terms Check [cite: 42-45]
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree to the Terms of Service"),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Bloc Event Trigger
    context.read<AuthBloc>().add(
      SignupRequested(
        params: SignupParams(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // سائن اپ کامیاب ہونے پر ہوم اسکرین پر جائیں
            context.goNamed(RouteNames.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title [cite: 29]
                    Text("Create Account", style: AppTypography.textTheme.displayMedium),
                    const SizedBox(height: 8),
                    Text(
                      "Join us and start your premium shopping journey.",
                      style: AppTypography.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 30),

                    // Full Name [cite: 33-34]
                    const Text("Full Name", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Enter your full name",
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (val) => AppValidators.validateRequired(val, 'Name'),
                    ),
                    const SizedBox(height: 20),

                    // Email [cite: 35-36]
                    const Text("Email Address", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Enter your email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: AppValidators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Phone (WooCommerce billing requirement)
                    const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "e.g., +92 300 1234567",
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: AppValidators.validatePhone,
                    ),
                    const SizedBox(height: 20),

                    // Password [cite: 37-39]
                    const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Create a strong password",
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: AppValidators.validatePassword,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Use 8+ characters with letters, numbers & symbols",
                      style: AppTypography.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password [cite: 40-41]
                    const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Re-enter your password",
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (val) => AppValidators.validateConfirmPassword(val, _passwordController.text),
                    ),
                    const SizedBox(height: 20),

                    // Terms & Conditions Checkbox [cite: 42-45]
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _agreedToTerms = val!),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "I agree to the ",
                              style: AppTypography.textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: "Terms of Service",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    // Open Terms URL
                                  },
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    // Open Privacy URL
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Create Account Button [cite: 46]
                    CustomButton(
                      text: "Create Account",
                      isLoading: isLoading,
                      onPressed: () => _onSignupPressed(context),
                    ),

                    const SizedBox(height: 24),

                    // Social Signup
                    const Center(child: Text("Or sign up with", style: TextStyle(color: AppColors.textSecondary))),
                    const SizedBox(height: 16),
                    const SocialLoginButtons(),

                    const SizedBox(height: 30),

                    // Already have account Link [cite: 47-48]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () => context.pushNamed(RouteNames.login),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}