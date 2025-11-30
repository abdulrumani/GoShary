import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_typography.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/services/di_container.dart';
import '../../../../core/widgets/custom_button.dart';

// Domain Imports
import '../../domain/usecases/verify_otp_usecase.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = "+1 (555) 123-4567",
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  int _start = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _resendCode() {
    setState(() {
      _start = 60;
      _pinController.clear();
    });
    startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code sent successfully!")),
    );
  }

  Future<void> _onVerify() async {
    final code = _pinController.text;
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter full 6-digit code")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final verifyOtp = sl<VerifyOtp>();
      final isVerified = await verifyOtp(
        VerifyOtpParams(phone: widget.phoneNumber, code: code),
      );

      if (isVerified && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification Successful!"),
            backgroundColor: AppColors.success,
          ),
        );
        context.goNamed(RouteNames.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Code. Please try again."),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        title: const Text("Verification"),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phonelink_lock,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Enter Verification Code",
                style: AppTypography.textTheme.displaySmall?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 12),
              Text(
                "We've sent a 6-digit code to",
                style: AppTypography.textTheme.bodyMedium,
              ),
              Text(
                widget.phoneNumber,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final isFilled = _pinController.text.length > index;
                      final isFocused = _pinController.text.length == index;
                      return Container(
                        width: 45,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isFilled ? Colors.white : AppColors.inputFill,
                          border: Border.all(
                            color: isFocused || isFilled
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isFilled ? _pinController.text[index] : "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: TextField(
                      controller: _pinController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (val) => setState(() {}),
                      decoration: const InputDecoration(counterText: ""),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive the code? "),
                  GestureDetector(
                    onTap: _start == 0 ? _resendCode : null,
                    child: Text(
                      _start == 0
                          ? "Resend Code"
                          : "Resend Code (00:${_start.toString().padLeft(2, '0')})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _start == 0 ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Verify & Continue",
                isLoading: _isLoading,
                onPressed: _onVerify,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.inputFill.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Security Check",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            "This helps us ensure the security of your account.",
                            style: AppTypography.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}