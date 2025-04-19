import 'package:broker/app/config/utils/app_utils/app_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_utils/app_strings.dart';
import '../../../core/heplers/validation_form.dart';

class VerifyCodeField extends StatelessWidget {
  final TextEditingController controller;
  const VerifyCodeField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) => ValidationForm.codeValidator(v, AppUtils.resetCode),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: AppStrings.reset,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      ),
    );
  }
}
