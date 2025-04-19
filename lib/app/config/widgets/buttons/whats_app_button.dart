import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../style/app_color.dart';
import '../../style/app_text_styles.dart';
import '../app_image_view.dart';

class WhatsAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? hight;
  const WhatsAppButton({super.key, required this.onPressed, this.hight});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h)),
          fixedSize: WidgetStatePropertyAll(Size(double.infinity, hight??32.h)),
          backgroundColor: WidgetStatePropertyAll(AppColors.green)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImageView(
            svgPath: Assets.assetsSvgWhatsApp,
            color: AppColors.white,
            height: 24.h,
            width: 24.w,
          ),
          4.ws,
          Text(
            AppStrings.whatsApp,
            style: AppTextStyle.font16white400,
          ),
        ],
      ),
    );
  }
}
