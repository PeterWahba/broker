import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/config/widgets/app_image_view.dart';
import 'package:broker/app/modules/layout/data/model/get_adv_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/style/app_color.dart';

class PropertyDetailsInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final bool isLocation;

  const PropertyDetailsInfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        AppImageView(
          svgPath: icon,
          height: 16.h,
          width: 16.w,
          color: AppColors.primary,
        ),
        Text("$title :", style: AppTextStyle.font14black400),
        Text(
          value,
          style:
              isLocation
                  ? AppTextStyle.font14primary600.copyWith(
                    decoration: TextDecoration.underline,
                  )
                  : AppTextStyle.font14black600,
        ),
      ],
    );
  }
}

class PropertyDetailsInfo extends StatelessWidget {
  final Details? details;
  const PropertyDetailsInfo({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      children: [
        PropertyDetailsInfoItem(
          title: AppStrings.property,
          value: details?.propertyFor ?? "",
          icon: Assets.assetsSvgPriceDetails,
        ),
        InkWell(
          onTap: () async {
            final Uri googleMapsUrl = Uri.parse(
              "geo:${details?.latitude},${details?.longitude}?q=${details?.latitude},${details?.longitude}",
            );

            if (await canLaunchUrl(googleMapsUrl)) {
              await launchUrl(
                googleMapsUrl,
                mode: LaunchMode.externalApplication,
              );
            } else {
              throw 'Could not open Google Maps.';
            }
          },
          child: PropertyDetailsInfoItem(
            isLocation: true,
            title: AppStrings.location,
            value: details?.governorateName ?? "",
            icon: Assets.assetsSvgLocation,
          ),
        ),
        details?.agreementStatusId == 2
            ? details?.type == 3
                ? PropertyDetailsInfoItem(
                  title: AppStrings.rent,
                  value:
                      "${details?.chaletRentValue} / ${details?.chaletRentTypeString}",
                  icon: Assets.assetsSvgPrice,
                )
                : PropertyDetailsInfoItem(
                  title: AppStrings.rent,
                  value: "${details?.price} / ${details?.rentValue}",
                  icon: Assets.assetsSvgPrice,
                )
            : PropertyDetailsInfoItem(
              title: AppStrings.price,
              value: "${details?.price}",
              icon: Assets.assetsSvgPrice,
            ),
        details?.type == 3 && details?.agreementStatusId == 2
            ? PropertyDetailsInfoItem(
              title: AppStrings.minimumTime,
              value: AppStrings.threeDays,
              icon: Assets.assetsSvgActive,
            )
            : PropertyDetailsInfoItem(
              title: AppStrings.propertyStatus,
              value: "${details?.buildingStatus}",
              icon: Assets.assetsSvgPropertyStatus,
            ),
        details?.type == 7
            ? PropertyDetailsInfoItem(
              title: AppStrings.usingFor,
              value: "${details?.usingForString}",
              icon: Assets.assetsSvgUsingFor,
            )
            : SizedBox(),
        PropertyDetailsInfoItem(
          title: AppStrings.views,
          value: "${details?.viewsCount.toString()}",
          icon: Assets.assetsSvgViews,
        ),
        PropertyDetailsInfoItem(
          title: AppStrings.documents,
          value: details?.document ?? "",
          icon: Assets.assetsSvgDocument,
        ),
      ],
    );
  }
}
