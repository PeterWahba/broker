import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/config/widgets/empty_widgets/empty_favorite.dart';
import 'package:broker/app/core/extentions/extention.dart';
import 'package:broker/app/config/widgets/drawer.dart';
import 'package:broker/app/modules/favorites/views/widgets/favorites_item.dart';
import 'package:broker/app/modules/layout/controllers/layout_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../config/widgets/empty_widgets/please_login_screen.dart';
import '../../../config/widgets/loading_widget.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  @override
  final FavoritesController controller = Get.put<FavoritesController>(
    FavoritesController(),
  );
  FavoritesView({super.key});
  @override
  Widget build(BuildContext context) {
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
                  // actions: [
                  //   TextButton(
                  //       onPressed: () {
                  //         showDialog(
                  //             context: context,
                  //             builder: (context) => ClearAllFavorites());
                  //       },
                  //       child: Text(AppStrings.clearAll))
                  // ],
                  leading: IconButton(
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  ),
                  title: Text(AppStrings.favorites),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    return await Get.find<LayoutController>().getFavorites();
                  },
                  child: Obx(() {
                    return Get.find<LayoutController>()
                                .favorites
                                .value
                                ?.favorites
                                ?.isNotEmpty ??
                            false
                        ? ListView.separated(
                          itemBuilder:
                              (context, index) => FavoritesItem(
                                favorites:
                                    Get.find<LayoutController>()
                                        .favorites
                                        .value
                                        ?.favorites?[index],
                              ),
                          separatorBuilder: (context, index) => 10.hs,
                          itemCount:
                              Get.find<LayoutController>()
                                  .favorites
                                  .value
                                  ?.favorites
                                  ?.length ??
                              0,
                        )
                        : EmptyFavorite();
                  }),
                ),
              ),
              Get.find<LayoutController>().getFavoritesLoading.value == true
                  ? const LoadingWidget()
                  : const SizedBox(),
            ],
          );
        });
  }
}
