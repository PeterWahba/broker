import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/modules/layout/data/model/get_last_ads_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../layout/controllers/layout_controller.dart';

class ListItem extends StatelessWidget {
  final Advertisements? advertisements;

  const ListItem({super.key, this.advertisements});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.propertyDetails);
        Get.find<LayoutController>().createViewForAdvertisement(advertisements?.id ?? 0);

        Get.find<LayoutController>().getAdvDetails(advertisements?.id ?? 0);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 8, // Blur radius
              offset: Offset(0, 4), // Offset for the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advertisements?.title ?? "",
                    style: AppTextStyle.font14black600,
                  ),
                  15.hs,
                  Text(
                    advertisements?.price??"",
                    style: AppTextStyle.font16primary600,
                  ),
                  15.hs,
                  // Row(
                  //   children: [
                  //     AppImageView(
                  //       svgPath: Assets.assetsSvgDoor,
                  //       height: 16.h,
                  //       width: 16.w,
                  //       color: AppColors.grey,
                  //     ),
                  //     Text(
                  //       "${advertisements?.rooms ?? 0}",
                  //       style: AppTextStyle.font14grey400,
                  //     ),
                  //     16.ws,
                  //     AppImageView(
                  //       svgPath: Assets.assetsSvgBed,
                  //       height: 16.h,
                  //       width: 16.w,
                  //       color: AppColors.grey,
                  //     ),
                  //     Text(
                  //       "${advertisements?.diningRoom ?? 0}",
                  //       style: AppTextStyle.font14grey400,
                  //     ),
                  //     16.ws,
                  //     AppImageView(
                  //       svgPath: Assets.assetsSvgPath,
                  //       height: 16.h,
                  //       width: 16.w,
                  //       color: AppColors.grey,
                  //     ),
                  //     Text(
                  //       advertisements?.area ?? "",
                  //       style: AppTextStyle.font14grey400,
                  //     ),
                  //   ],
                  // ),
                  // 8.hs,
                  FutureBuilder<String>(
                    future: Get.find<LayoutController>().getAddressFromLatLng(advertisements?.latitude, advertisements?.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("جاري التحميل...", style: AppTextStyle.font12black400);
                      } else if (snapshot.hasError) {
                        return Text("خطأ في التحميل", style: AppTextStyle.font12black400);
                      } else {
                        return Text(
                          snapshot.data ?? "موقع غير متوفر",
                          style: AppTextStyle.font12black400,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: AppImageView(
                radius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                  url: advertisements?.photos?[0]??"" , height: 105.h,width: 140.w,),
            )
          ],
        ),
      ),
    );
  }
}
