import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/widgets/form_fields/area_field.dart';
import 'package:broker/app/config/widgets/form_fields/building_area_field.dart';
import 'package:broker/app/config/widgets/form_fields/building_date_field.dart';
import 'package:broker/app/config/widgets/form_fields/building_length_field.dart';
import 'package:broker/app/config/widgets/form_fields/building_width_field.dart';
import 'package:broker/app/config/widgets/form_fields/level_field.dart';
import 'package:broker/app/config/widgets/form_fields/street_width_field.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/modules/add_property/views/widgets/check_widget.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/utils/app_utils/app_strings.dart';
import '../../../../../config/widgets/buttons/button_1.dart';
import '../../../../../config/widgets/buttons/outlined_app_button.dart';
import '../../../controllers/add_apartment_controller.dart';
import '../../widgets/selection_widget.dart';

class AddApartmentStage2 extends GetView<AddApartmentController> {
  const AddApartmentStage2({super.key});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Form(
          key: controller.secondStageFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.propertyDetails,
                style: AppTextStyle.font16black400,
              ),
              24.verticalSpace,
              controller.selectedAdType.value == 7 ? _landFields() : SizedBox(),
              controller.selectedAdType.value != 7
                  ? AreaField(controller: controller.areaController)
                  : SizedBox(),
              controller.selectedAdType.value == 6
                  ? Column(
                    children: [
                      24.verticalSpace,
                      StreetWidthField(
                        controller: controller.streetWidthController,
                      ),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value == 4
                  ? Column(
                    children: [
                      24.verticalSpace,
                      BuildingAreaField(
                        controller: controller.buildingAreaController,
                      ),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value != 6 &&
                      controller.selectedAdType.value != 7
                  ? Column(
                    children: [
                      24.verticalSpace,
                      LevelField(controller: controller.levelController),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value == 4
                  ? Column(
                    children: [
                      24.verticalSpace,
                      SelectionWidget(
                        controller: controller.selectedBuildingUsingFor,
                        listLenght: 2,
                        labels: [AppStrings.residential, AppStrings.commercial],
                        title: AppStrings.usingFor,
                        icon: Assets.assetsSvgUsingFor,
                        onChanged: (onChanged) {},
                      ),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value != 7
                  ? Column(
                    spacing: 24.h,
                    children: [
                      1.verticalSpace,
                      SelectionWidget(
                        controller: controller.propertyStatus,
                        listLenght: 3,
                        labels: [
                          AppStrings.newString,
                          AppStrings.usedString,
                          AppStrings.renewedString,
                        ],
                        onChanged: (value) {
                          controller.selectedPropertyLabel.value = value;
                        },
                        title: AppStrings.propertyStatus,
                        icon: Assets.assetsSvgPropertyStatus,
                      ),
                      SelectionWidget(
                        controller: controller.finishing,
                        listLenght: 4,
                        onChanged: (value) {
                          controller.selectedFinishingLabel.value = value;
                        },
                        labels: [
                          AppStrings.withoutString,
                          AppStrings.semiFinishedString,
                          AppStrings.fullString,
                          AppStrings.highQualityString,
                        ],
                        title: AppStrings.finishing,
                        icon: Assets.assetsSvgFinishing,
                      ),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value == 5
                  ? Column(
                    children: [
                      24.verticalSpace,
                      SelectionWidget(
                        controller: controller.selectedOfficeNumber,
                        listLenght: 5,
                        onChanged: (value) {},
                        labels: ["0", "1", "2", "3", "4+"],
                        title: AppStrings.officesNo,
                        icon: Assets.assetsSvgDoor,
                      ),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value == 1 ||
                      controller.selectedAdType.value == 2 ||
                      controller.selectedAdType.value == 3
                  ? _baseSelection()
                  : SizedBox(),
              controller.selectedAdType.value == 4
                  ? _buildingPartitionsSelection()
                  : SizedBox(),
              controller.selectedAdType.value != 6 &&
                      controller.selectedAdType.value != 7
                  ? Column(
                    children: [
                      24.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: CheckWidget(
                              controller: controller.isFurnished,
                              icon: Assets.assetsSvgFurnished,
                              title: AppStrings.furnished,
                            ),
                          ),
                          Expanded(
                            child: CheckWidget(
                              controller: controller.hasElevator,
                              icon: Assets.assetsSvgElevator,
                              title: AppStrings.elevator,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : SizedBox(),
              Row(
                children: [
                  controller.selectedAdType.value == 1 ||
                          controller.selectedAdType.value == 2 ||
                          controller.selectedAdType.value == 3
                      ? Expanded(
                        child: CheckWidget(
                          hasSpacer: true,
                          controller: controller.hasParking,
                          icon: Assets.assetsSvgParking,
                          title: AppStrings.parking,
                        ),
                      )
                      : SizedBox(),
                  controller.selectedAdType.value == 2 ||
                          controller.selectedAdType.value == 3
                      ? Expanded(
                        child: CheckWidget(
                          controller: controller.hasPool,
                          icon: Assets.assetsSvgPool,
                          title: AppStrings.pool,
                        ),
                      )
                      : SizedBox(),
                ],
              ),
              controller.selectedAdType.value != 6 &&
                      controller.selectedAdType.value != 7
                  ? Row(
                    children: [
                      Expanded(
                        child: CheckWidget(
                          controller: controller.hasGarden,
                          icon: Assets.assetsSvgGarden,
                          title: AppStrings.garden,
                        ),
                      ),
                      Obx(() {
                        return Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            enabled: controller.hasGarden.value,
                            keyboardType: TextInputType.number,
                            controller: controller.gardenAreaController,
                            decoration: InputDecoration(
                              labelText: AppStrings.areaString,
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                  : SizedBox(),
              controller.selectedAdType.value == 5
                  ? _officeFields()
                  : SizedBox(),
              controller.selectedAdType.value == 4
                  ? _buildingFields()
                  : SizedBox(),
              24.verticalSpace,
              SelectionWidget(
                controller: controller.documents,
                listLenght: 4,
                onChanged: (value) {
                  controller.selectedDocumentsLabel.value = value;
                },
                labels: [
                  AppStrings.registeredString,
                  AppStrings.unregisteredString,
                  AppStrings.registrableString,
                  AppStrings.unregistrableString,
                ],
                title: AppStrings.documents,
                icon: Assets.assetsSvgDocument,
              ),
              24.verticalSpace,
              _facilitiesChecks(),
              24.verticalSpace,
              Row(
                spacing: 8.w,
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
                  Expanded(
                    child: AppButton1(
                      title: AppStrings.next,
                      onPressed: () {
                        controller.checkSecondStageForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildingFields() => Column(
    spacing: 24.h,
    children: [
      1.verticalSpace,
      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasShop,
              icon: Assets.assetsSvgShop,
              title: AppStrings.shop,
            ),
          ),
          8.ws,
          Obx(() {
            return Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: controller.hasShop.value,
                keyboardType: TextInputType.number,
                controller: controller.noShopsController,
                decoration: InputDecoration(labelText: AppStrings.shop),
              ),
            );
          }),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasParking,
              icon: Assets.assetsSvgParking,
              title: AppStrings.parking,
            ),
          ),
          8.ws,
          Obx(() {
            return Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: controller.hasParking.value,
                keyboardType: TextInputType.number,
                controller: controller.parkingSpaceController,
                decoration: InputDecoration(labelText: AppStrings.parking),
              ),
            );
          }),
        ],
      ),
      BuildingDateField(controller: controller.buildingDateController),
      Row(
        spacing: 8.w,
        children: [
          Expanded(
            child: BuildingWidthField(
              controller: controller.buildingWidthController,
            ),
          ),
          Expanded(
            child: BuildingLengthField(
              controller: controller.buildingLengthController,
            ),
          ),
        ],
      ),
    ],
  );
  Widget _facilitiesChecks() => Column(
    spacing: 24.h,
    children: [
      Row(
        children: [
          AppImageView(
            svgPath: Assets.assetsSvgFacilites,
            height: 16.h,
            width: 16.w,
          ),
          8.ws,
          Text(AppStrings.facilities, style: AppTextStyle.font16grey600),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasWater,
              icon: Assets.assetsSvgWater,
              title: AppStrings.water,
            ),
          ),
          Expanded(
            child: CheckWidget(
              controller: controller.hasGas,
              icon: Assets.assetsSvgGas,
              title: AppStrings.gas,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasElectricity,
              icon: Assets.assetsSvgElectricity,
              title: AppStrings.electricity,
            ),
          ),
          Expanded(
            child: CheckWidget(
              controller: controller.hasPhone,
              icon: Assets.assetsSvgPhone,
              title: AppStrings.phone,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasInternet,
              icon: Assets.assetsSvgInternet,
              title: AppStrings.internet,
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    ],
  );
  Widget _buildingPartitionsSelection() => Column(
    spacing: 24.h,
    children: [
      1.verticalSpace,
      SelectionWidget(
        controller: controller.selectedNoUnits,
        listLenght: 5,
        onChanged: (value) {},
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.noOfUnits,
        icon: Assets.assetsSvgDoor,
      ),
      SelectionWidget(
        controller: controller.selectedNoPartitions,
        listLenght: 5,
        onChanged: (value) {},
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.noOfPartitions,
        icon: Assets.assetsSvgNoPartitions,
      ),
    ],
  );
  Widget _baseSelection() => Column(
    spacing: 24.h,
    children: [
      24.verticalSpace,
      SelectionWidget(
        controller: controller.selectedRooms,
        listLenght: 5,
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.rooms,
        icon: Assets.assetsSvgDoor,
        onChanged: (value) {
          controller.selectedRoomLabel.value = value;
        },
      ),
      SelectionWidget(
        onChanged: (value) {
          controller.selectedRecieptionLabel.value = value;
        },
        controller: controller.recieption,
        listLenght: 5,
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.reception,
        icon: Assets.assetsSvgBed,
      ),
      SelectionWidget(
        controller: controller.dining,
        listLenght: 5,
        onChanged: (value) {
          controller.selectedDiningLabel.value = value;
        },
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.dining,
        icon: Assets.assetsSvgDining,
      ),
      SelectionWidget(
        controller: controller.balcony,
        listLenght: 5,
        onChanged: (value) {
          controller.selectedBalconyLabel.value = value;
        },
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.balcony,
        icon: Assets.assetsSvgBalcony,
      ),
      SelectionWidget(
        controller: controller.kitchen,
        listLenght: 5,
        onChanged: (value) {
          controller.selectedKitchenLabel.value = value;
        },
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.kitchen,
        icon: Assets.assetsSvgKitchen,
      ),
      SelectionWidget(
        controller: controller.toilet,
        listLenght: 5,
        onChanged: (value) {
          controller.selectedToiletLabel.value = value;
        },
        labels: ["0", "1", "2", "3", "4+"],
        title: AppStrings.toilet,
        icon: Assets.assetsSvgPath,
      ),
    ],
  );
  Widget _officeFields() => Column(
    spacing: 24.h,
    children: [
      1.verticalSpace,
      Row(
        children: [
          Expanded(
            child: CheckWidget(
              controller: controller.hasParking,
              icon: Assets.assetsSvgParking,
              title: AppStrings.parking,
            ),
          ),
          8.ws,
          Obx(() {
            return Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enabled: controller.hasParking.value,
                keyboardType: TextInputType.number,
                controller: controller.parkingSpaceController,
                decoration: InputDecoration(labelText: AppStrings.parking),
              ),
            );
          }),
        ],
      ),
      StreetWidthField(controller: controller.streetWidthController),
    ],
  );
  Widget _landFields() => Column(
    spacing: 24.h,
    children: [
      1.verticalSpace,
      Row(
        spacing: 8.w,
        children: [
          Expanded(child: AreaField(controller: controller.areaController)),
          Expanded(
            child: StreetWidthField(
              controller: controller.streetWidthController,
            ),
          ),
        ],
      ),
      Row(
        spacing: 8.w,
        children: [
          Expanded(
            child: BuildingWidthField(
              controller: controller.buildingWidthController,
            ),
          ),
          Expanded(
            child: BuildingLengthField(
              controller: controller.buildingLengthController,
            ),
          ),
        ],
      ),
      SelectionWidget(
        controller: controller.landingStatus,
        listLenght: 2,
        labels: [AppStrings.empty, AppStrings.used],
        title: AppStrings.propertyStatus,
        icon: Assets.assetsSvgPropertyStatus,
        onChanged: (onChanged) {},
      ),
      SelectionWidget(
        controller: controller.selectedBuildingUsingFor,
        listLenght: 4,
        labels: [
          AppStrings.buildings,
          AppStrings.industrial,
          AppStrings.agriculture,
          AppStrings.investment,
        ],
        title: AppStrings.usingFor,
        icon: Assets.assetsSvgUsingFor,
        onChanged: (onChanged) {},
      ),
    ],
  );
}
