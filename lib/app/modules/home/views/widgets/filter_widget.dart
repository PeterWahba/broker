import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/modules/layout/controllers/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 20.0.w),
        margin: EdgeInsets.only(right: 8.0), // Adds spacing between items
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class ApartmentFilterScreen extends StatelessWidget {
  ApartmentFilterScreen({
    super.key,
  });

  final List<String> filterOptions = [
    AppStrings.all,
    AppStrings.apartmentsForSale,
    AppStrings.apartmentsForRent,
    AppStrings.villasForSale,
    AppStrings.villasForRent,
    AppStrings.chaletsForSale,
    AppStrings.chaletsForRent,
    AppStrings.buildingsForSale,
    AppStrings.buildingsForRent,
    AppStrings.officesForSale,
    AppStrings.officesForRent,
    AppStrings.shopsForSale,
    AppStrings.shopsForRent,
    AppStrings.landsForSale,
    AppStrings.landsForRent,
  ];

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final LayoutController layoutController = Get.find<LayoutController>();

    return ValueListenableBuilder<int>(
      valueListenable: homeController.selectedIndexNotifier,
      builder: (context, selectedIndex, _) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
          scrollDirection: Axis.horizontal,
          itemCount: filterOptions.length,
          itemBuilder: (context, index) {
            return FilterButton(
              label: filterOptions[index],
              isSelected: selectedIndex == index,
              onTap: () {
                homeController.selectedIndexNotifier.value = index;
                layoutController.getAllAdvertisement(index: index);
                layoutController.resetFilters();
              },
            );
          },
        );
      },
    );
  }
}
