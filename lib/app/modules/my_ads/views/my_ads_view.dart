import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/config/widgets/empty_widgets/empty_ads.dart';
import 'package:broker/app/config/widgets/empty_widgets/please_login_screen.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/drawer.dart';
import 'package:broker/app/modules/my_ads/controllers/my_ads_controller.dart';
import 'package:broker/app/modules/my_ads/views/widgets/adds_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../config/widgets/loading_widget.dart';
import '../../../config/widgets/pop_ups/clear_all_ads.dart';
import '../../../core/services/storage_service.dart';
import '../../layout/controllers/layout_controller.dart';

class MyAdsView extends GetView<MyAdsController> {
  const MyAdsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(MyAdsController());

    return StorageService.getData("token") == null &&
            StorageService.getData("userId") == null
        ? PleaseLoginScreen()
        : Obx(() {
          return Stack(
            children: [
              Scaffold(
                key: controller.scaffoldKey,
                drawer: DrawerWidget(),
                appBar: AppBar(
                  actions: [
                    Get.find<LayoutController>()
                                .getAllAdsForUserModel
                                .value
                                ?.advertisements
                                ?.isNotEmpty ??
                            false
                        ? TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ClearAllAds(),
                            );
                          },
                          child: Text(AppStrings.clearAll),
                        )
                        : SizedBox.shrink(),
                  ],
                  leading: IconButton(
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  ),
                  title: Text(AppStrings.myAds),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    return await Get.find<LayoutController>()
                        .getAllAdvertisementForUser();
                  },
                  child: Obx(() {
                    return Get.find<LayoutController>()
                                .getAllAdsForUserModel
                                .value
                                ?.advertisements
                                ?.isNotEmpty ??
                            false
                        ? ListView.separated(
                          itemBuilder:
                              (context, index) => AddsItem(
                                advertisements:
                                    Get.find<LayoutController>()
                                        .getAllAdsForUserModel
                                        .value
                                        ?.advertisements?[index],
                              ),
                          separatorBuilder: (context, index) => 10.hs,
                          itemCount:
                              Get.find<LayoutController>()
                                  .getAllAdsForUserModel
                                  .value
                                  ?.advertisements
                                  ?.length ??
                              0,
                        )
                        : EmptyAds();
                  }),
                ),
              ),
              Get.find<LayoutController>()
                          .getAllAdvertisementForUserLoading
                          .value ==
                      true
                  ? const LoadingWidget()
                  : const SizedBox(),
            ],
          );
        });
  }
}
