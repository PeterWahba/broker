import 'package:broker/app/config/widgets/appbars/list_view_app_bar.dart';
import 'package:broker/app/config/widgets/loading_widget.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/modules/list_view/views/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../config/widgets/drawer.dart';
import '../../layout/controllers/layout_controller.dart';
import '../controllers/list_view_controller.dart';

class ListViewView extends GetView<ListViewController> {
  @override
  final ListViewController controller = Get.put<ListViewController>(
    ListViewController(),
  );
  ListViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            drawer: DrawerWidget(),
            key: controller.scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0.h),
              child: ListViewAppBar(
                onPressed: () {
                  controller.scaffoldKey.currentState!.openDrawer();
                },
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                return await Get.find<LayoutController>().getAllAdvertisement();
              },
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder:
                    (context, index) => ListItem(
                      advertisements:
                          Get.find<LayoutController>()
                              .allAdsModel
                              .value
                              ?.advertisements?[index],
                    ),
                separatorBuilder: (context, index) => 10.hs,
                itemCount:
                    Get.find<LayoutController>()
                        .allAdsModel
                        .value
                        ?.advertisements
                        ?.length ??
                    0,
              ),
            ),
          ),
          Get.find<LayoutController>().isLoading.value == true
              ? const LoadingWidget()
              : const SizedBox(),
        ],
      );
    });
  }
}
