import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/config/widgets/buttons/button_1.dart';
import 'package:broker/app/config/widgets/buttons/outlined_app_button.dart';
import 'package:broker/app/config/widgets/form_fields/description_field.dart';
import 'package:broker/app/modules/add_property/views/widgets/add_property_image.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../config/utils/app_utils/app_strings.dart';
import '../../../../../config/widgets/buttons/button_2.dart';
import '../../../controllers/add_apartment_controller.dart';

class AddApartmentStage3 extends GetView<AddApartmentController> {
  const AddApartmentStage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.selectedAdType.value == 1
              ? AppStrings.addApartment
              : controller.selectedAdType.value == 2
              ? AppStrings.addVilla
              : controller.selectedAdType.value == 3
              ? AppStrings.addChalet
              : controller.selectedAdType.value == 4
              ? AppStrings.addBuilding
              : controller.selectedAdType.value == 5
              ? AppStrings.addOffice
              : controller.selectedAdType.value == 6
              ? AppStrings.addShop
              : AppStrings.addLand,
        ),
      ),
      body: Form(
        key: controller.thirdStageFormKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            Text(AppStrings.propertyPhotos, style: AppTextStyle.font16black400),
            16.hs,
            Obx(() {
              return Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 12.w,
                  runSpacing: 8.w,
                  children: List.generate(
                    controller.imageFiles.length < 3
                        ? 3
                        : controller.imageFiles.length,
                    (index) => AddPropertyImage(
                      index: index,
                      controller: controller,
                    ),
                  ),
                ),
              );
            }),
            32.hs,
            Obx(() {
              // Example: Enable/disable button based on imageFiles length
              return OutlinedAppButton(
                onPressed:
                    controller.imageFiles.length < 6
                        ? () => showModalBottomSheet(
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          backgroundColor: Colors.white,
                          context: context,
                          builder:
                              (builder) => Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                child: Column(
                                  spacing: 18.h,
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    AppButton1(
                                      title: AppStrings.camera,
                                      onPressed: () {
                                        controller.addImages(
                                          ImageSource.camera,
                                        );
                                        Get.back();
                                      },
                                    ),
                                    AppButton2(
                                      title: AppStrings.gallery,
                                      onPressed: () {
                                        controller.addImages(
                                          ImageSource.gallery,
                                        );
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        )
                        : null, // Disable button when 3 or more images
                title: AppStrings.addMorePhotos,
              );
            }),

            10.hs,
            Text(AppStrings.addClearImages, style: AppTextStyle.font12grey400),

            // وصف العقار
            20.hs,
            Row(
              children: [
                AppImageView(
                  svgPath: Assets.assetsSvgDescribtion,
                  height: 16.h,
                  width: 16.w,
                  color: AppColors.grey,
                ),
                8.ws,
                Text(
                  AppStrings.propertyDescription,
                  style: AppTextStyle.font16black600,
                ),
              ],
            ),
            16.hs,
            DescriptionField(controller: controller.descriptionController),
            20.hs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedAppButton(
                    title: AppStrings.back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                11.ws,
                Expanded(
                  child: AppButton1(
                    title: AppStrings.next,
                    onPressed: () {
                      controller.checkThirdStageForm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
