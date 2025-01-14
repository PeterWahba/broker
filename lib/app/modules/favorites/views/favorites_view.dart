import 'package:broker/app/config/utils/extentions/extention.dart';
import 'package:broker/app/config/widgets/drawer.dart';
import 'package:broker/app/modules/favorites/views/widgets/favorites_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
      @override
      final FavoritesController controller =
      Get.put<FavoritesController>(FavoritesController());
   FavoritesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: DrawerWidget(),
        appBar: AppBar(
          actions: [TextButton(onPressed: (){}, child: Text("Clear All"))],
      leading: IconButton(
        onPressed: () {
          controller.scaffoldKey.currentState!.openDrawer();
        },
        icon: Icon(
          Icons.menu,
        ),
      ),
      title: Text("Favorites"),
        ),
        
        body: ListView.separated(
            itemBuilder: (context, index) => FavoritesItem(),
            separatorBuilder: (context, index) => 10.hs,
            itemCount: 20));
  }
}
