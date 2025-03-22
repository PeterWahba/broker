import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/utils/app_utils/app_utils.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../style/app_text_styles.dart';
import '../../../core/heplers/validation_form.dart';



class CodeField extends StatelessWidget {
  final TextEditingController? controller;
  final String?code;

  const CodeField({super.key, this.controller, this.code});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode=="ar"?TextDirection.ltr:TextDirection.rtl,
      child: PinCodeTextField(
        
        appContext: context,
        pastedTextStyle: const TextStyle(
          color: AppColors.desSelected,
          fontWeight: FontWeight.bold,
        ),
        length: 4,
        animationType: AnimationType.fade,
        validator: (v)=>ValidationForm.codeValidator(v,AppUtils.otp),
        mainAxisAlignment: MainAxisAlignment.center,
        pinTheme: PinTheme(
          
          shape: PinCodeFieldShape.box,
          
          fieldHeight: 56.h,
          fieldWidth: 75.w,
          borderWidth: 1,
          activeBorderWidth: 1,
          inactiveBorderWidth: 1,
          selectedBorderWidth: 1,
          borderRadius: BorderRadius.circular(8),
          fieldOuterPadding: EdgeInsets.zero,
          inactiveFillColor: Colors.transparent,
          inactiveColor: AppColors.primary,
          selectedFillColor: Colors.transparent,
          selectedColor: AppColors.primary,
          activeFillColor: Colors.transparent,
          activeColor: AppColors.primary,
        ),
        separatorBuilder: (context, index) => 8.ws,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        cursorColor: AppColors.primary,
        textStyle: AppTextStyle.font16black500,
        controller: controller,
        errorTextSpace: 30.h,
        errorTextDirection: TextDirection.rtl,
        keyboardType: TextInputType.number,
        onCompleted: (v) {},
        onChanged: (value) {},
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }
}
