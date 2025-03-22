import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/style/app_color.dart';
import '../../../../config/widgets/app_image_view.dart';
import '../../../../config/widgets/buttons/button_1.dart';
import '../../../../config/widgets/buttons/button_2.dart';
import '../../controllers/edit_apartment_controller.dart';

class AddPropertyImageEdit extends StatelessWidget {
  final int index;
  final EditApartmentController controller;
  const AddPropertyImageEdit({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          InkWell(
            onTap: () {
              if (controller.apiPhotosList.length < 3) {
                showModalBottomSheet(
                  constraints: BoxConstraints(maxWidth: double.infinity),

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
                                controller.addImages(index, ImageSource.camera);
                                Get.back();
                              },
                            ),
                            AppButton2(
                              title: AppStrings.gallery,
                              onPressed: () {
                                controller.addImages(
                                  index,
                                  ImageSource.gallery,
                                );
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                );
              }
            },
            child: Container(
              width: 90.w,
              height: 90.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(75),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  index < controller.apiPhotosList.length
                      ? AppImageView(
                        radius: BorderRadius.circular(12),
                        file: controller.imageFiles[index],
                        url: controller.apiPhotosList[index],
                        fit: BoxFit.fill,
                      )
                      : Icon(Icons.add, color: AppColors.grey, size: 40),
            ),
          ),
          if (index < controller.apiPhotosList.length)
            Positioned(
              bottom: 0,
              left: 1,
              child: InkWell(
                onTap: () {
                  controller.removeImage(index);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(75),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 16.h,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
