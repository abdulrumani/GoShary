import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/config/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          context,
          iconPath: AppConstants.googleIcon,
          provider: 'google',
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          context,
          iconPath: AppConstants.appleIcon,
          provider: 'apple',
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          context,
          iconPath: AppConstants.facebookIcon,
          provider: 'facebook',
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, {required String iconPath, required String provider}) {
    return InkWell(
      onTap: () {
        context.read<AuthBloc>().add(SocialLoginRequested(provider: provider));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        // اگر آپ کے پاس assets نہیں ہیں تو یہ ایرر دے گا، اس لیے فی الحال آئیکن استعمال کر رہے ہیں
        // child: Image.asset(iconPath, height: 24, width: 24),
        child: Icon(
          provider == 'google' ? Icons.g_mobiledata :
          provider == 'apple' ? Icons.apple : Icons.facebook,
          size: 28,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}