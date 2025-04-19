import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/config/widgets/drawer.dart';
import 'package:broker/app/config/widgets/appbars/home_app_bar.dart';
import 'package:broker/app/modules/home/controllers/home_controller.dart';
import 'package:broker/app/modules/home/views/widgets/filter_widget.dart';
import 'package:broker/app/modules/layout/controllers/layout_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends GetView<HomeController> {
  @override
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutController = Get.find<LayoutController>();


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          controller.getCurrentPosition();
        },
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: DrawerWidget(),
      key: controller.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0.h),
        child: HomeAppBar(
          onPressed: () => controller.scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: Obx(() {
        final position = controller.currentPosition.value;

        if (position == const LatLng(0, 0)) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              initialCameraPosition: controller.initialCameraPosition,
              onMapCreated: controller.onMapCreate,
              onCameraIdle: () async {
                controller.getAddress();
              },
              onCameraMove: controller.onCameraMove,
              myLocationEnabled: true,
              mapType: MapType.normal, // Use MapType.none for minimal rendering
              trafficEnabled: false,
              buildingsEnabled: false,
              indoorViewEnabled: false,
              // padding: EdgeInsets.only(bottom: 140.h),
              markers: layoutController.markers.value ?? {},

              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              gestureRecognizers:
                  <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
              // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
              //     Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
            ),
            SizedBox(height: 60.h, child: ApartmentFilterScreen()),
          ],
        );
      }),
    );
  }
}
