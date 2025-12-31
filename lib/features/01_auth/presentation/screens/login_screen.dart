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
import '../../domain/usecases/login_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_tabController.index == 0) {
      if (_emailFormKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
        context.read<AuthBloc>().add(
          LoginRequested(
            params: LoginParams(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          ),
        );
      }
    } else {
      if (_phoneFormKey.currentState!.validate()) {
        context.pushNamed(RouteNames.otpVerification);
      }
    }
  }

  // --- Skip Action ---
  void _onSkipPressed(BuildContext context) {
    // مہمان (Guest) کے طور پر ہوم پر جائیں
    context.goNamed(RouteNames.home);
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
        actions: [
          TextButton(
            onPressed: () => _onSkipPressed(context),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign In", style: AppTypography.textTheme.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    "Welcome back! Please enter your details.",
                    style: AppTypography.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),

                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: "Email"),
                        Tab(text: "Phone"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // --- Email Form ---
                        Form(
                          key: _emailFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: "Enter your password",
                                controller: _passwordController,
                                isPassword: true,
                                prefixIcon: Icons.lock_outline,
                                validator: AppValidators.validatePassword,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.primary,
                                        onChanged: (val) => setState(() => _rememberMe = val!),
                                      ),
                                      const Text("Remember me"),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("Forgot Password?", style: TextStyle(color: AppColors.error)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // --- Phone Form ---
                        Form(
                          key: _phoneFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: "e.g., +92 300 1234567",
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icons.phone_outlined,
                                validator: AppValidators.validatePhone,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "We will send you a verification code via SMS.",
                                style: AppTypography.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  CustomButton(
                    text: "Sign In",
                    isLoading: isLoading,
                    onPressed: () => _onLoginPressed(context),
                  ),

                  const SizedBox(height: 24),
                  const Center(child: Text("Or sign in with", style: TextStyle(color: AppColors.textSecondary))),
                  const SizedBox(height: 16),

                  // ✅ Social Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google
                      SocialButton(
                        icon: "assets/icons/google.png",
                        onTap: () {
                          // ✅ Google Event Trigger
                          context.read<AuthBloc>().add(const LoginWithSocialEvent(provider: 'google'));
                        },
                      ),
                      const SizedBox(width: 16),

                      // Facebook
                      SocialButton(
                        icon: "assets/icons/facebook.png",
                        onTap: () {
                          context.read<AuthBloc>().add(const LoginWithSocialEvent(provider: 'facebook'));
                        },
                      ),
                      const SizedBox(width: 16),

                      // Apple
                      SocialButton(
                        icon: "assets/icons/apple.png",
                        onTap: () {
                          context.read<AuthBloc>().add(const LoginWithSocialEvent(provider: 'apple'));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => context.pushNamed(RouteNames.signup),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ✅ SocialButton Widget (Updated Color)
class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          // 👇 یہ لائن کلر کا مسئلہ حل کرے گی (AppColors.inputBorder کی جگہ)
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(icon),
      ),
    );
  }
}