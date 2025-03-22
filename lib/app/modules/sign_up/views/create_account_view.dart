import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/config/widgets/buttons/sign_up_button.dart';
import 'package:broker/app/modules/sign_up/controllers/sign_up_controller.dart';
import 'package:broker/app/routes/app_pages.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';


class CreateAccountView extends GetView<SignUpController> {
  const CreateAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings.createAccount),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w,vertical:24.h,),
        child: SingleChildScrollView(
          child: Column(
            spacing: 24.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppStrings.im,style: AppTextStyle.font16black600,)),
              AppImageView(imagePath: Assets.assetsImagesSignUp,width: 250.w,height: 240.h,),
              SignUpButton(icon: Assets.assetsSvgSearch, title: AppStrings.propertySeeker, onPressed: () {
                controller.selectedIndex.value=0;
                Get.toNamed(Routes.signUp);
              }),
              SignUpButton(icon: Assets.assetsSvgUser, title: AppStrings.propertyOwner, onPressed: () {
                controller.selectedIndex.value=1;
                Get.toNamed(Routes.signUp);
              }),
              SignUpButton(icon: Assets.assetsSvgBroker, title: AppStrings.broker, onPressed: () {
                controller.selectedIndex.value=2;
                Get.toNamed(Routes.signUp);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
