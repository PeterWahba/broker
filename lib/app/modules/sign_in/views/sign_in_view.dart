import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_scaffold.dart';
import 'package:broker/app/config/widgets/buttons/button_1.dart';
import 'package:broker/app/config/widgets/form_fields/password_field.dart';
import 'package:broker/app/config/widgets/form_fields/phone_number_field.dart';
import 'package:broker/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../config/style/app_color.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.signIn,
          style: AppTextStyle.font16black600,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 24.h,
          ),
          children: [
            Text(
              AppStrings.welcome,
              style: AppTextStyle.font18black400,
            ),
            24.hs,
            PhoneNumberField(controller: controller.phoneNumberController),
            24.hs,
            PasswordField(controller: controller.passwordController),
            16.hs,
            Align(
              alignment: Get.locale?.languageCode == 'ar' ? Alignment.topRight : Alignment.topLeft,
              child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.forgetPassword);
                  },
                  child: Text(
                    AppStrings.forgetPassword,
                    style: AppTextStyle.font16black400,
                  )),
            ),
            24.hs,
            Obx(() {
              return AppButton1(
                title: controller.isLoading.value ? "" : AppStrings.signIn,
                leading: controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppColors.white,
                      ))
                    : null,
                onPressed: controller.isLoading.value ? null : controller.login,
              );
            }),
            24.hs,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.newUser,
                  style: AppTextStyle.font16black400,
                ),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.createAccount);
                    },
                    child: Text(
                      AppStrings.createAccount,
                      style: AppTextStyle.font16primary600,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
