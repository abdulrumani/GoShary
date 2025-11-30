import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // اسکرین کا سائز لے آؤٹ کو ریسپانسیو بنانے کے لیے
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // 1. Logo & Image Section
              // فی الحال ہم پلیس ہولڈر آئیکن استعمال کر رہے ہیں، آپ یہاں اپنی امیج لگا سکتے ہیں
              Container(
                height: size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 2. Welcome Text [cite: 6-7]
              Text(
                "Welcome to ${AppConstants.appName}",
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text(
                "Discover premium products at your fingertips. The best shopping experience awaits you.",
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyMedium,
              ),

              const Spacer(flex: 2),

              // 3. Buttons Section [cite: 9-11]

              // Sign In Button
              CustomButton(
                text: "Sign In",
                onPressed: () {
                  context.pushNamed(RouteNames.login);
                },
              ),

              const SizedBox(height: 16),

              // Create Account Button
              CustomButton(
                text: "Create Account",
                isOutlined: true, // سفید بٹن
                onPressed: () {
                  context.pushNamed(RouteNames.signup);
                },
              ),

              const SizedBox(height: 24),

              // Continue as Guest Button
              TextButton(
                onPressed: () {
                  // مہمان کو سیدھا ہوم پر بھیجیں
                  context.goNamed(RouteNames.home);
                },
                child: const Text(
                  "Continue as Guest",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 4. Terms & Privacy [cite: 12-14]
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By continuing, you agree to our ",
                    style: AppTypography.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " & "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}