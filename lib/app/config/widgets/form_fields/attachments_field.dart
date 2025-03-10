import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_utils/app_strings.dart';
import '../../../core/heplers/validation_form.dart';


class AttachmentsField extends StatelessWidget {
  final TextEditingController controller;
  const AttachmentsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      validator: ValidationForm.nameValidator,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
         
        icon:  AppImageView(svgPath: Assets.assetsSvgAttachments,height: 24.h,width: 24.w,),

        hintText: AppStrings.attachments,
        contentPadding:
            EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      ),
    );
  }
}
