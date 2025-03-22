import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/widgets/app_scaffold.dart';
import 'package:broker/app/config/widgets/buttons/button_1.dart';
import 'package:broker/app/modules/edit_property/controllers/edit_apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/utils/app_utils/app_strings.dart';
import '../../../../../config/widgets/pop_ups/under_review.dart';
import '../../../../../routes/app_pages.dart';

class EditPaymentStage extends GetView<EditApartmentController> {
  const EditPaymentStage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(AppStrings.payment)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.adType,
                style: AppTextStyle.font24black400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16.w,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectAd(0); // Index of Premium Ad
                      Get.toNamed(Routes.editPremiumPaymentStage);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 40.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.h,
                        children: [
                          Icon(
                            Icons.star_border_outlined,
                            color: AppColors.white,
                            size: 48,
                          ),
                          Text(
                            AppStrings.premiumAd,
                            style: AppTextStyle.font18white400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectAd(1); // Index of Free Ad
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 40.h,
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.freeAd,
                          style: AppTextStyle.font18white400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.grey),
                Text(
                  AppStrings.premiumAdAdvantages,
                  style: AppTextStyle.font16black400,
                ),
              ],
            ),
            Text(
              AppStrings.increaseInViewership,
              style: AppTextStyle.font14black400,
            ),
            Text(
              AppStrings.appearsInGoldColor,
              style: AppTextStyle.font14black400,
            ),
            Text(AppStrings.showsRemotely, style: AppTextStyle.font14black400),
            Obx(() {
              return AppButton1(
                title:
                    controller.selectedAdIndex.value == 1
                        ? AppStrings.publishFreeAd
                        : AppStrings.publish,
                onPressed: () {
                  controller.selectedAdIndex.value == 1
                      ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder:
                            (s) => UnderReview(
                              button: Obx(() {
                                return AppButton1(
                                  leading:
                                      controller
                                                  .editAdvertisementLoading
                                                  .value ==
                                              true
                                          ? CircularProgressIndicator(color: Colors.white,)
                                          : SizedBox.shrink(),
                                  title:controller
                                                  .editAdvertisementLoading
                                                  .value ==
                                              true
                                          ?"": AppStrings.done,
                                  onPressed: () {
                                   controller
                                                  .editAdvertisementLoading
                                                  .value ==
                                              true
                                          ?null: controller.editAdvertisement();
                                  },
                                );
                              }), isLoading: controller
                                                  .editAdvertisementLoading
                                                  .value,
                            ),
                      )
                      : null;
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
