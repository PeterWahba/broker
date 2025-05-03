import 'dart:async';
import 'dart:io';
import 'package:broker/app/config/utils/app_utils/app_strings.dart';
import 'package:broker/app/modules/home/data/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/style/app_color.dart';
import '../../../core/heplers/image_picker.dart';
import '../../../core/heplers/map_utils.dart';
import '../../../core/services/storage_service.dart';
import '../data/models/suggestion_model.dart';
import '../views/drawer_screens/search_screen.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var rating = 3.0.obs;

  // Use Rx to minimize unnecessary rebuilds
  final searchController = TextEditingController();
  final emailController = TextEditingController();
  final textSubjectController = TextEditingController();

  final HomeProvider _homeProvider = HomeProvider();

  // Optimize Image Handling
  Rxn<File> imageFile = Rxn<File>();
  var imageName = "".obs;

  void addImages() async {
    var image = await ImagePickerUtils.getImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile.value = image;
      imageName.value = image.path.split('/').last;
    }
  }

  // Map related variables
  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  final Rx<LatLng> currentPosition = Rx<LatLng>(const LatLng(0, 0));
  final RxString address = RxString('');
  final RxBool loadingAddress = RxBool(false);
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(30.06263, 31.24967), // Center of Egypt
    zoom: 7,
  );
  void init([LatLng? location]) {
    if (location != null) {
      initialCameraPosition = CameraPosition(target: location, zoom: 15);
      currentPosition.value = location;
    }
  }

  void onMapCreate(GoogleMapController mapController) {
    if (controller.isCompleted) {
      controller = Completer<GoogleMapController>(); // 🆕 Reset the controller
    }

    controller.complete(mapController);
  }

  void getCurrentPosition() {
    MapUtils.getCurrentPosition()
        .then((value) {
          final position = LatLng(value.latitude, value.longitude);

          // Check if the position is outside Egypt
          if (position.latitude < 22.0 ||
              position.latitude > 31.5 ||
              position.longitude < 25.0 ||
              position.longitude > 35.0) {
            // Set to Egypt's center if outside bounds
            currentPosition.value = const LatLng(30.06263, 31.24967);
          } else {
            currentPosition.value = position;
          }

          _moveCamera();
        })
        .catchError((e) {
          // Handle error if needed
        });
  }

  void _moveCamera() {
    MapUtils.moveCamera(
      controller: controller,
      target: currentPosition.value,
      zoom: 7,
    );
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  Future<void> getAddress() async {
    loadingAddress.value = true;
    final result = await _homeProvider.getAddress(currentPosition.value);
    // address.value = result;
    loadingAddress.value = false;
  }

  Future<void> searchPlace(BuildContext context) async {
    final SuggestionModel? result = await showSearch(
      context: context,
      delegate: AddressSearch(currentPosition.value, _homeProvider),
    );
    if (result != null) {
      final place = await _homeProvider.getPlaceDetailFromId(result.placeId);
      final lat = place.result?.geometry?.location?.lat;
      final lng = place.result?.geometry?.location?.lng;
      if (lat != null && lng != null) {
        currentPosition.value = LatLng(lat, lng);
        _moveCamera();
        address.value = result.description;
      }
    }
  }

  Future<void> addRate(double rate) async {
    final userId = StorageService.getData("userId") ?? 0; // Cache userId
    final userRateData = {"userId": userId, "userRate": "${rate.toInt()}"};

    final response = await _homeProvider.addRate(data: userRateData);

    response.fold((l) {
      _showMessage(
        l['result']["success"] == "true"
            ? AppStrings.successfulRating
            : AppStrings.youHaveAlreadySubmittedYourRating,
        isError: false,
      );
    }, (r) => _showMessage(r.message, isError: true));
  }

  // Contact Us
  Future<void> addContactUs() async {
    final userId = StorageService.getData("userId");
    final contactData = {
      "emailAddress": emailController.text,
      "emailSubject": textSubjectController.text,
      "attachmentPath": imageName.value,
      "userId": userId,
    };

    final response = await _homeProvider.addContactUs(data: contactData);
    response.fold(
      (l) => _showMessage(
        AppStrings.contactRequestSentSuccessfully,
        isError: false,
      ),
      (r) => _showMessage(r.message, isError: true),
    );
  }

  // Show Messages
  void _showMessage(String message, {bool isError = true}) {
    Get.snackbar(
      isError ? "Error" : "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColors.primary,
    );
  }

  // Tab Bar Navigation Optimization
  final selectedIndexNotifier = ValueNotifier<int>(0);

  void changeIndex(int index) {
    selectedIndexNotifier.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    init();

    getCurrentPosition();
  }
}
