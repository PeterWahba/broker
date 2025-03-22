import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/config/widgets/buttons/button_1.dart';
import 'package:broker/app/config/widgets/buttons/outlined_app_button.dart';
import 'package:broker/app/modules/layout/controllers/layout_controller.dart';
import 'package:broker/app/modules/layout/data/model/get_last_ads_response_model.dart';
import 'package:broker/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MapDetails extends StatelessWidget {
  final Advertisements advertisements;
  const MapDetails({super.key, required this.advertisements});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LayoutController>();
    return AlertDialog(
      
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
        vertical: 20.h,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              advertisements.title ?? "",
              style: AppTextStyle.font12black400.copyWith(height: 1.5.h),
            ),
          ),
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
            url: advertisements.photos?[0] ?? "",
            height: 150.h,
            width: 250.w,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(8),
          ),
        ],
      ),
      actions: [
        Obx(() => AppButton1(
            title: controller.isLoading.value 
                ? ''
                : AppStrings.details,
            onPressed: controller.isLoading.value 
                ? null
                : () {
                    Get.find<LayoutController>()
                        .getAdvDetails(advertisements.id ?? 0)
                        ;
                      Navigator.of(Get.context??context).pop();
                      Get.toNamed(Routes.propertyDetails);
                    
                },
            leading: controller.isLoading.value 
                ? Center(child: CircularProgressIndicator(color: Colors.white,))
                : null,
        )),
        12.hs,
        Obx(() => OutlinedAppButton(
          title: AppStrings.cancel,
          onPressed: controller.isLoading.value 
              ? null
              : () => Navigator.of(context).pop(),
        )),
      ],
    );
  }
}
