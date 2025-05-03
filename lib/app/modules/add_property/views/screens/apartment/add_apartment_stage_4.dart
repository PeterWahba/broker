import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_scaffold.dart';
import 'package:broker/app/core/heplers/validation_form.dart';
import 'package:broker/app/modules/home/views/widgets/selection_row_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../config/utils/app_utils/app_strings.dart';
import '../../../../../config/widgets/app_image_view.dart';
import '../../../../../config/widgets/buttons/button_1.dart';
import '../../../../../config/widgets/buttons/outlined_app_button.dart';
import '../../../controllers/add_apartment_controller.dart';
import '../../widgets/currency_text_input_formatter.dart';
import '../../widgets/selection_widget.dart';

class AddApartmentStage4 extends GetView<AddApartmentController> {
  const AddApartmentStage4({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(controller.selectedAdType.value == 1
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
                                : AppStrings.addLand,)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Form(
          key: controller.forthStageFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24.h,
            children: [
              Text(AppStrings.propertyPricing, style: AppTextStyle.font18black600),
              controller.selectedContractType.value == 1&&controller.selectedAdType.value==3?
              Column(
                spacing: 24.h,
                children: [
                  
            Obx(
               () {
                return Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        value: '1',
                        groupValue: controller.selectedOption.value,
                        onChanged: (value) {
                          controller.updateSelectedOption(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller.dayController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppStrings.days),
                        enabled: controller.selectedOption.value == '1',
                      ),
                    ),
                    16.horizontalSpace, 
                    Expanded(
                      child: RadioListTile<String>(
                        value: '2',
                        groupValue: controller.selectedOption.value,
                        onChanged: (value) {
                          controller.updateSelectedOption(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller.weekController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: AppStrings.week),
                        enabled: controller.selectedOption.value == '2',
                      ),
                    ),
                  ],
                );
              }
            ),
            const Text(
                'You can modify the rental value during the ad display period from the list of my ads'),
            SelectionWidget(
                controller: controller.selectedMinTime,
                listLenght: 2,
                labels: [AppStrings.threeDays, AppStrings.week],
                title: AppStrings.minTimeToBook,
                icon: Assets.assetsSvgActive,
                onChanged: (v) {}),
           
                ],
              ):
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) => ValidationForm.priceValidator(value, type: controller.selectedContractType.value),
                controller: controller.priceController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyTextInputFormatter(), // Custom formatter for currency
                ],
                decoration: InputDecoration(
                  icon: AppImageView(
                    svgPath: Assets.assetsSvgPrice,
                    height: 16.h,
                    width: 16.w,
                  ),
                  prefixText: 'EGP ',
                ),
              ),
              controller.selectedContractType.value == 1&&controller.selectedAdType.value!=3
                  ? Row(
                      children: [
                        AppImageView(
                          svgPath: Assets.assetsSvgRent,
                          height: 16.h,
                          width: 16.w,
                          color: AppColors.grey,
                        ),
                        16.ws,
                        Expanded(
                          child: SelectionRowWidget(
                            controller: controller.rent,
                            listLenght: 3,
                            labels: [AppStrings.monthly, AppStrings.midTerm, AppStrings.annual],
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: OutlinedAppButton(
                    title: AppStrings.back,
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  )),
                  11.ws,
                  Expanded(
                      child: AppButton1(
                    title: AppStrings.next,
                    onPressed: () {
                      controller.checkForthStageForm();
                    },
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
