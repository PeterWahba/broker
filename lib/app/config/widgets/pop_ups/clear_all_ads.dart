import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/config/widgets/buttons/button_1.dart';
import 'package:broker/app/config/widgets/buttons/outlined_app_button.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../modules/layout/controllers/layout_controller.dart';

class ClearAllAds extends StatelessWidget {
  const ClearAllAds({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
        vertical: 20.h,
      ),
      title: Row(
        children: [
          Text(
            AppStrings.clearAds,
            style: AppTextStyle.font18black600,
          ),
          Spacer(),
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: AppColors.grey,
              ))
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImageView(
            imagePath: Assets.assetsImagesWarning,
            height: 150.h,
            width: 150.w,
          ),
          16.hs,
          Text(
            AppStrings.areYouSureToClearAds,
            textAlign: TextAlign.center,
            style: AppTextStyle.font16black400,
          ),
        ],
      ),
      actions: [
        AppButton1(title: AppStrings.clear, onPressed: () {
          Get.find<LayoutController>()
                            .deleteAllByUserIdAdvertisement();
            Navigator.of(context).pop(); // إغلاق النافذة المنبثقة

        }),
        12.hs,
        OutlinedAppButton(
          title: AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(),),
      ],
    );
  }
}
