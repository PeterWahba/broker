import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/core/heplers/firebase_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../config/style/app_color.dart';
import '../../../config/utils/app_utils/app_utils.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_pages.dart';
import '../data/provider/login_provider.dart';

class SignInController extends GetxController {
  final LoginProvider _loginProvider = LoginProvider();

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> codeFormKey = GlobalKey<FormState>();

  final count = 0.obs;
  final isLoading = false.obs;

  // Validates and submits the form
  bool _submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  void submitCodeForm() async {
    if (codeFormKey.currentState!.validate()) {
      // Get.snackbar("Success", StorageService.getData("token")??"no token");
      await StorageService.setData("userId", AppUtils.userId ?? 0);

      Get.offAllNamed(Routes.home);
    }
  }

  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(1),
  );

  // Handles user login
  Future<void> login() async {
    if (_submitForm()) {
      isLoading.value = true;
      final loginData = {
        'userNameOrEmailAddress': phoneNumberController.text,
        'password': passwordController.text,
        "rememberClient": "true",
        "registrationDevice":await FirebaseNotifications.token(),
      };

      try {
        final response = await _loginProvider.loginUser(data: loginData);

        if (response.statusCode == 200) {
          AppUtils.token = response.data?.accessToken ?? "";
          AppUtils.userId = response.data?.userId ?? 0;

          // Send OTP after successful login
          await _sendOtp();

          Get.offAllNamed(Routes.verification);
        } else {
          _showError(AppStrings.invalidCredentials);
        }
      } catch (e) {
        _showError(AppStrings.invalidCredentials);
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Sends OTP
  Future<void> _sendOtp() async {
    final checkData = {'phoneNumber': phoneNumberController.text};

    try {
      final response = await _loginProvider.checkOtp(data: checkData);

      if (response.statusCode == 200) {
        AppUtils.phoneNumber = phoneNumberController.text;
        AppUtils.otp = response.data?.otp;
        // Get.snackbar("Success", "OTP sent: ${response.data?.otp}");
      } else {
        _showError("Failed to send OTP");
      }
    } catch (e) {
      _showError("An error occurred while sending OTP");
    }
  }

  Future<void> resendOtp() async {
    final checkData = {'phoneNumber': AppUtils.phoneNumber};

    try {
      final response = await _loginProvider.checkOtp(data: checkData);

      if (response.statusCode == 200) {
        AppUtils.otp = response.data?.otp;
        stopWatchTimer.onStartTimer();
        // Get.snackbar("Success", "OTP sent: ${response.data?.otp}");
      } else {
        _showError("Failed to send OTP");
      }
    } catch (e) {
      _showError("An error occurred while sending OTP");
    }
  }

  // Helper to show error messages
  void _showError(String message) {
    Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM,
              colorText: AppColors.primary
);
  }

  // Increment counter
  void increment() => count.value++;

  @override
  void onClose() {
    phoneNumberController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // Check if the current view is VerificationView
    if (Get.currentRoute == Routes.verification) {
      stopWatchTimer.onStartTimer();
      // Debugging line to check if the timer starts
    }
  }
}
