import 'package:get/get.dart';

class LayoutController extends GetxController {
  //TODO: Implement LayoutController


  final count = 0.obs;
   final selectedIndex = 0.obs;

     void changeIndex(int index) {
       selectedIndex.value = index;
     }
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}


