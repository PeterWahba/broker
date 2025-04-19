import 'dart:async';
import 'dart:io' show File;

import 'package:broker/app/core/heplers/date_format_helper.dart';
import 'package:broker/app/core/heplers/file_helper.dart';
import 'package:broker/app/modules/add_property/data/models/get_all_governates_model.dart';
import 'package:broker/app/modules/edit_property/data/models/get_adv_details_model.dart';
import 'package:broker/app/modules/edit_property/views/screens/apartment/edit_paymob_screen.dart';
import 'package:broker/app/modules/layout/controllers/layout_controller.dart';
import 'package:broker/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/style/app_color.dart';
import '../../../config/utils/app_utils/app_strings.dart';
import '../../../core/heplers/map_utils.dart';
import '../../../core/services/storage_service.dart';
import '../../add_property/data/models/get_all_durations_model.dart';
import '../../add_property/data/models/get_discount_model.dart';
import '../../add_property/data/models/get_url_model.dart';
import '../../home/data/models/suggestion_model.dart';
import '../data/provider/edit_property_provider.dart';
import '../views/widgets/search_screen.dart';

class EditApartmentController extends GetxController {
  final EditPropertyProvider _editPropertyProvider = EditPropertyProvider();
  final selectedDuration = 0.obs;

  final RxBool isWhatsAppAvailable = false.obs;
  final allGovernates = Rxn<GetAllGovernatesModel>();
  final url = Rxn<GetUrlModel>();

  final isPremium = false.obs;
  final discountCode = TextEditingController();
  var isFurnished = false.obs;
  var hasElevator = false.obs;
  var hasParking = false.obs;
  var hasShop = false.obs;
  var hasGarden = false.obs;
  var hasPool = false.obs;
  var isRegistered = false.obs;
  var hasWater = false.obs;
  var hasGas = false.obs;
  var hasElectricity = false.obs;
  var hasPhone = false.obs;
  var hasInternet = false.obs;
  var selectedContractType = 0.obs; // 1 = For Sell, 2 = For Rent
  var selectedContractTypeLabel = Rxn<String>();
  var propertyStatus = 0.obs;
  var landingStatus = 0.obs;
  var finishing = 0.obs;
  var rent = 0.obs;
  var selectedRooms = 0.obs;
  var selectedNoUnits = 0.obs;
  var selectedNoPartitions = 0.obs;
  var selectedBuildingUsingFor = 0.obs;
  var selectedOfficeFloors = 0.obs;
  var selectedOfficeNumber = 0.obs;
  var selectedGovernate = Rxn<String>();
  var selectedMrMrs = Rxn<String>();
  var selectedBrokerOwner = Rxn<String>();
  var selectedRoomLabel = Rxn<String>();
  var selectedRecieptionLabel = Rxn<String>();
  var selectedPropertyLabel = Rxn<String>();
  var selectedFinishingLabel = Rxn<String>();
  var selectedDiningLabel = Rxn<String>();
  var selectedBalconyLabel = Rxn<String>();
  var selectedKitchenLabel = Rxn<String>();
  var selectedDocumentsLabel = Rxn<String>();
  var selectedToiletLabel = Rxn<String>();
  var selectedGovernateId = RxnInt();
  var recieption = 0.obs;
  var dining = 0.obs;
  var balcony = 0.obs;
  var kitchen = 0.obs;
  var toilet = 0.obs;
  RxInt documents = 0.obs;

  var imageFiles = <File?>[].obs;
  var imageNames = <String>[].obs; // قائمة جديدة لحفظ أسماء الصور
  var apiPhotosList = <String>[].obs; // قائمة جديدة لحفظ أسماء الصور

  final getAdsDetailsLodaing = false.obs;
  final editAdvertisementLoading = false.obs;
  final advDetailsModel = Rxn<GetAdvDetailsForEditModel>(); // Make it reactive

  final buildingNoController = TextEditingController();
  final whatsappController = TextEditingController();
  final gardenAreaController = TextEditingController();
  final districtController = TextEditingController();
  final streetController = TextEditingController();
  final titleController = TextEditingController();
  final areaController = TextEditingController();
  final buildingAreaController = TextEditingController();
  final noShopsController = TextEditingController();
  final buildingWidthController = TextEditingController();
  final buildingLengthController = TextEditingController();
  final buildingDateController = TextEditingController();
  final parkingSpaceController = TextEditingController();
  final priceController = TextEditingController();
  final levelController = TextEditingController();
  final descriptionController = TextEditingController();
  final streetWidthController = TextEditingController();
  final weekController = TextEditingController();
  final dayController = TextEditingController();

  var currentLocation = Rxn<Position>();

  var firstApartmentStageData = Rxn<Map<String, dynamic>>();

  var secondApartmentStageData = Rxn<Map<String, dynamic>>();

  var thirdApartmentStageData = Rxn<Map<String, dynamic>>();

  var forthApartmentStageData = Rxn<Map<String, dynamic>>();

  var fifthApartmentStageData = Rxn<Map<String, dynamic>>();
  var sixthApartmentStageData = Rxn<Map<String, dynamic>>();

  final firstStageFormKey = GlobalKey<FormState>();
  final secondStageFormKey = GlobalKey<FormState>();
  final thirdStageFormKey = GlobalKey<FormState>();
  final forthStageFormKey = GlobalKey<FormState>();
  final fifthStageFormKey = GlobalKey<FormState>();
  final sixthStageFormKey = GlobalKey<FormState>();

  RxString selectedAddress = RxString("Fetching address...");

  var selectedAdIndex = 0.obs; // متغير لتخزين الفهرس المحدد للإعلان
  var selectedAdType = 0.obs;
  var selectedMinTime = 0.obs;

  var selectedOption = Rxn<String>(); // متغير لتخزين الخيار المحدد

  //add check for the formfield to be submitted or not
  void checkFirstStageForm() {
    if (firstStageFormKey.currentState!.validate()) {
      if (currentLocation.value == null) {
        Get.snackbar(
          "Error",
          AppStrings.pleaseSelectLocation,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColors.primary,
        );
      } else {
        Get.toNamed(Routes.editApartmentStage2);
        saveDataFromFirstStage();
      }
    }
  }

  void checkSecondStageForm() {
    if (secondStageFormKey.currentState?.validate() ?? false) {
      Get.toNamed(Routes.editApartmentStage3);
      saveDataFromSecondStage();
    }
  }

  void checkThirdStageForm() {
    if (thirdStageFormKey.currentState!.validate()) {
      if (apiPhotosList.isEmpty) {
        Get.snackbar(
          "Error",
          AppStrings.pleaseAddAtLeastOneImage,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColors.primary,
        );
      } else {
        Get.toNamed(Routes.editApartmentStage4);
        saveDataFromThirdStage();
      }
    }
  }

  void checkForthStageForm() {
    if (forthStageFormKey.currentState!.validate()) {
      if (selectedAdType.value == 3 &&
          selectedContractType.value == 1 &&
          selectedOption.value != "") {
        if (dayController.text != '' || weekController.text != '') {
          Get.toNamed(Routes.editApartmentStage5);
          saveDataFromForthStage();
        } else {
          _showError(AppStrings.pleaseFillOutFields);
        }
      } else {
        Get.toNamed(Routes.editApartmentStage5);
        saveDataFromForthStage();
      }
    }
  }

  void checkFifthStageForm() {
    if (fifthStageFormKey.currentState!.validate()) {
      Get.toNamed(Routes.editApartmentStage6);
      saveDataFromFifthStage();
    }
  }

  void checkSixthStageForm() {
    if (sixthStageFormKey.currentState!.validate()) {
      Get.toNamed(Routes.editPaymentStage);
      saveDataFromSixthStage();
    }
  }

  void saveDataFromSecondStage() {
    secondApartmentStageData.value = {
      "area": areaController.text,
      "buildingArea":
          selectedAdType.value == 4 ? buildingAreaController.text : "",
      "usingFor":
          selectedAdType.value == 4
              ? "${selectedBuildingUsingFor.value + 5}"
              : selectedAdType.value == 7
              ? "${selectedBuildingUsingFor.value + 1}"
              : "",
      "numUnits": selectedAdType.value == 4 ? "${selectedNoUnits.value}" : "0",
      "numPartitions":
          selectedAdType.value == 4 ? "${selectedNoPartitions.value}" : "0",
      "shop": selectedAdType.value == 4 ? "${hasShop.value}" : "",
      "shopsNumber":
          selectedAdType.value == 4 && noShopsController.text != ""
              ? noShopsController.text
              : "",
      "parkingSpace":
          selectedAdType.value == 4 && parkingSpaceController.text != ""
              ? parkingSpaceController.text
              : "",
      "buildingDate":
          selectedAdType.value == 4 && buildingDateController.text != ""
              ? buildingDateController.text
              : "",
      "width":
          (selectedAdType.value == 4 || selectedAdType.value == 7) &&
                  buildingWidthController.text != ""
              ? buildingWidthController.text
              : "",
      "length":
          (selectedAdType.value == 4 || selectedAdType.value == 7) &&
                  buildingLengthController.text != ""
              ? buildingLengthController.text
              : "",
      "officesFloors":
          selectedAdType.value == 5 ? "${selectedOfficeFloors.value}" : "",
      "officesNum":
          selectedAdType.value == 5 ? "${selectedOfficeNumber.value}" : "",
      "streetWidth":
          (selectedAdType.value == 5 ||
                      selectedAdType.value == 6 ||
                      selectedAdType.value == 7) &&
                  streetWidthController.text != ""
              ? streetWidthController.text
              : "",
      "floorsNumber": levelController.text,
      "rooms": "${selectedRooms.value}",
      "reception": "${recieption.value}",
      "dinning": "${dining.value}",
      "balcony": "${balcony.value}",
      "kitchen": "${kitchen.value}",
      "toilet": "${toilet.value}",
      "furnished": "${isFurnished.value}",
      "elevator": "${hasElevator.value}",
      "parking": "${hasParking.value}",
      "garden": "${hasGarden.value}",
      "gardenArea": gardenAreaController.text,
      "buildingStatus": "${propertyStatus.value + 1}",
      "landingStatus": "${landingStatus.value + 1}",
      "decoration": "${finishing.value + 1}",
      "document": "${documents.value + 1}",
      "AdvertisementFacilitesList":
          [
            hasWater.value ? 31 : null,
            hasElectricity.value == true ? 30 : null,
            hasInternet.value == true ? 29 : null,
            hasGas.value == true ? 28 : null,
            hasPhone.value == true ? 27 : null,
          ].where((item) => item != null).toList(),
    };
  }

  void saveDataFromFirstStage() {
    firstApartmentStageData.value = {
      "agreementStatus": "${selectedContractType.value + 1}",
      "title": titleController.text,
      "governorateId": selectedGovernateId.value,
      "street": streetController.text,
      "buildingNumber": buildingNoController.text,
      "compound": districtController.text,
      "latitude": currentLocation.value?.latitude,
      "longitude": currentLocation.value?.longitude,
    };
  }

  void saveDataFromThirdStage() {
    thirdApartmentStageData.value = {
      "description": descriptionController.text,
      "photosList":
          apiPhotosList
              .map(
                (url) => url.replaceFirst(
                  "http://backend.brokerapp.me/Resources/UploadFiles/",
                  "",
                ),
              )
              .toList(),
    };
  }

  void saveDataFromForthStage() {
    forthApartmentStageData.value = {
      "price": selectedAdType.value != 3 ? priceController.text : "0",
      "rent":
          selectedContractType.value == 1 && selectedAdType.value != 3
              ? "${rent.value + 1}"
              : "0",
      "chaletRentType":
          selectedAdType.value == 3 && selectedContractType.value == 1
              ? selectedOption.value
              : "",
      "chaletRentValue":
          selectedAdType.value == 3 && selectedContractType.value == 1
              ? dayController.text == ""
                  ? weekController.text
                  : dayController.text
              : "",
      "numOfMonths": "1",
      "minTimeToBookForChaletId": selectedMinTime.value == 0 ? "1035" : "1034",
    };
  }

  void saveDataFromFifthStage() {
    fifthApartmentStageData.value = {
      "mrMrs": selectedMrMrs.value == "Mr" ? "1" : "2",
      "advertiseMaker": selectedBrokerOwner.value == "Owner" ? "1" : "2",
    };
  }

  void saveDataFromSixthStage() {
    fifthApartmentStageData.value = {
      "isWhatsApped": "${isWhatsAppAvailable.value}",
      "secondMobileNumber":
          isWhatsAppAvailable.value == true ? whatsappController.text : "",
      "featuredAd": "false",
    };
  }

  @override
  void onClose() {
    // Dispose of controllers when the controller is destroyed
    titleController.dispose();
    buildingNoController.dispose();
    whatsappController.dispose();
    gardenAreaController.dispose();
    districtController.dispose();
    streetController.dispose();
    areaController.dispose();
    levelController.dispose();
    priceController.dispose();
    descriptionController.dispose();

    // إعادة تعيين القيم الافتراضية
    selectedContractType.value = 0;
    rent.value = 0;
    propertyStatus.value = 0;
    selectedGovernate.value = null;
    finishing.value = 0;
    selectedRooms.value = 0;
    recieption.value = 0;
    dining.value = 0;
    balcony.value = 0;
    kitchen.value = 0;
    toilet.value = 0;
    documents.value = 0;

    super.onClose();
  }

  final RxDouble discount = 0.0.obs;
  final getDiscount = Rxn<GetDiscountModel>();
  final allDurations = Rxn<GetAllDurationsModel>();

  Future<void> getAllDurations() async {
    final getAllDurationsData = {"start": "0", "length": "100"};

    final response = await _editPropertyProvider.getAllDurations(
      getAllDurationsData,
    );

    response.fold((l) async {
      allDurations.value = GetAllDurationsModel.fromJson(l['result']);
    }, (r) => _showError(r.message));
  }

  Future<void> checkCoupon() async {
    final getAllDurationsData = {"keyword": discountCode.text};

    final response = await _editPropertyProvider.checkCoupon(
      getAllDurationsData,
    );

    response.fold((l) async {
      getDiscount.value = GetDiscountModel.fromJson(l['result']);
      if (getDiscount.value?.success == false) {
        _showError("Invalid Discount Code");
      } else {
        discount.value = getDiscount.value?.discount;
      }
    }, (r) => _showError(r.message));
  }

  void addImages(int index, ImageSource source) async {
    if (source == ImageSource.gallery) {
      List<XFile>? images = await ImagePicker().pickMultiImage();

      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          XFile image = images[i];
          String imageName = image.path.split('/').last;
          File file = File(image.path);

          // Ensure imageFiles list is big enough
          if (index + i < imageFiles.length) {
            imageFiles[index + i] = file;
          } else {
            imageFiles.add(file);
          }

          uploadImage(file);
          apiPhotosList.add(imageName);
        }
      }
    } else if (source == ImageSource.camera) {
      XFile? image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        String imageName = image.path.split('/').last;
        File file = File(image.path);

        if (index < imageFiles.length) {
          imageFiles[index] = file;
        } else {
          imageFiles.add(file);
        }

        uploadImage(file);
        apiPhotosList.add(imageName);
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < apiPhotosList.length) {
      apiPhotosList.removeAt(index);
    }
  }

  Future<void> getPaymentUrl(String amount) async {
    try {
      final getPaymentUrlData = {
        "amount": amount,
        "userId": StorageService.getData("userId"),
      };

      final response = await _editPropertyProvider.getPaymentUrl(
        getPaymentUrlData,
      );

      response.fold((l) {
        url.value = GetUrlModel.fromJson(l['result']);
        if (url.value?.isSuccess == true) {
          Get.to(() => EditPaymobScreen(paymentUrl: url.value?.url ?? ""));
        }
      }, (r) => _showError(r.message));
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.primary,
      );
    }
  }

  Future<void> editAdvertisement() async {
    editAdvertisementLoading.value = true;

    final createAdvertisementData = {
      "id": advDetailsModel.value?.id ?? 0,
      "type": selectedAdType.value,
      "seekerId": StorageService.getData("seekerId") ?? "0",
      "brokerPersonId": StorageService.getData("brokerId") ?? "0",
      "ownerId": StorageService.getData("ownerId") ?? "0",
      "paymentFacility": "1",
      "isPublish": "true",
      "advertiseMakerName":
          StorageService.getData("userName") ??
          "${Get.find<LayoutController>().userData.value?.details?.name}",
      "contactRegisterInTheAccount": "true",
      "mobileNumber": StorageService.getData("phoneNumber") ?? "0",
      "pool":
          selectedAdType.value == 2 || selectedAdType.value == 3
              ? "${hasPool.value}"
              : "false",
      ...?firstApartmentStageData.value, // استخدام spread operator
      ...?secondApartmentStageData.value, // استخدام spread operator
      ...?thirdApartmentStageData.value, // استخدام spread operator
      ...?forthApartmentStageData.value, // استخدام spread operator
      ...?fifthApartmentStageData.value, // استخدام spread operator
      ...?sixthApartmentStageData.value, // استخدام spread operator
    };

    final response = await _editPropertyProvider.editAdvertisement(
      createAdvertisementData,
    );

    response.fold((l) async {
      if (l['success'] == true) {
        editAdvertisementLoading.value = false;
        Get.offAllNamed(Routes.home);
        Get.find<LayoutController>().getAllAdvertisementForUser();
      }
    }, (r) => _showError(r.message));
  }

  Future<void> getAdvDetailsForEdit(int advertiseId) async {
    getAdsDetailsLodaing.value = true;
    final getAdvDetailsData = {
      'userId': StorageService.getData("userId") ?? 0,
      'advertiseId': advertiseId,
    };

    final response = await _editPropertyProvider.getAdvDetailsForEdit(
      data: getAdvDetailsData,
    );

    response.fold((l) async {
      advDetailsModel.value = GetAdvDetailsForEditModel.fromJson(
        l['result']['advertisement'],
      );
      getAdsDetailsLodaing.value = false;
    }, (r) => _showError(r.message));
  }

  void showLocationPicker(BuildContext context) {
    LatLng initialPosition = LatLng(30.0444, 31.2357); // Default: Cairo
    Rx<LatLng> selectedPosition = Rx(initialPosition);

    // Function to get address from coordinates
    Future<void> getAddressFromLatLng(LatLng position) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          List<String> addressParts =
              [
                place.street,
                place.locality,
              ].whereType<String>().where((part) => part.isNotEmpty).toList();

          selectedAddress.value = addressParts.join(', ');

          if (place.street != null) {
            streetController.text = place.street!;
          }
          if (place.locality != null) {
            districtController.text = place.locality!;
          }
        } else {
          selectedAddress.value = "لم يتم العثور على عنوان لهذا الموقع";
        }
      } catch (e) {
        selectedAddress.value = "تعذر جلب العنوان. يرجى المحاولة مرة أخرى.";
      }
    }

    // Get initial address
    getAddressFromLatLng(initialPosition);

    Get.to(
      () => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.selectLocation),
          actions: [
            IconButton(
              onPressed: () {
                currentLocation.value = Position(
                  latitude: selectedPosition.value.latitude,
                  longitude: selectedPosition.value.longitude,
                  timestamp: DateTime.now(),
                  accuracy: 1,
                  altitude: 0,
                  heading: 0,
                  speed: 0,
                  speedAccuracy: 0,
                  altitudeAccuracy: 0,
                  headingAccuracy: 0,
                );
                Get.back();
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Obx(() {
                return TextFormField(
                  onTap: () {
                    searchPlace(context);
                  },
                  controller: TextEditingController(text: address.value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: "ابحث عن موقع",
                  ),
                  readOnly: true,
                );
              }),
            ),
            Expanded(
              child: Stack(
                children: [
                  Obx(
                    () => GoogleMap(
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: onMapCreate,
                      onCameraIdle: () async {
                        getAddress();
                      },
                      onCameraMove: onCameraMove,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      trafficEnabled: false,
                      buildingsEnabled: false,
                      indoorViewEnabled: false,
                      markers: {
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: selectedPosition.value,
                        ),
                      },
                      onTap: (LatLng latLng) {
                        selectedPosition.value = latLng;
                        getAddressFromLatLng(latLng);
                      },
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: false,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                    ),
                  ),
                  Positioned(
                    bottom: 16.h,
                    left: 60.w,
                    right: 60.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(75),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(
                        () => Text(
                          selectedAddress.value,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  final Rx<LatLng> currentPosition = Rx<LatLng>(const LatLng(0, 0));
  final RxString address = RxString('');
  final RxBool loadingAddress = RxBool(false);
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(30.06263, 31.24967), // Center of Egypt
    zoom: 5,
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
          currentPosition.value = LatLng(value.latitude, value.longitude);
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
      zoom: 15,
    );
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  Future<void> getAddress() async {
    loadingAddress.value = true;
    final result = await _editPropertyProvider.getAddress(
      currentPosition.value,
    );
    // address.value = result;
    loadingAddress.value = false;
  }

  Future<void> searchPlace(BuildContext context) async {
    final SuggestionModel? result = await showSearch(
      context: context,
      delegate: AddressSearch(currentPosition.value, _editPropertyProvider),
    );
    if (result != null) {
      final place = await _editPropertyProvider.getPlaceDetailFromId(
        result.placeId,
      );
      final lat = place.result?.geometry?.location?.lat;
      final lng = place.result?.geometry?.location?.lng;
      if (lat != null && lng != null) {
        currentPosition.value = LatLng(lat, lng);
        _moveCamera();
        address.value = result.description;
      }
    }
  }

  Future<void> getAllGovernates() async {
    final getAllGovernatesData = {"start": "0", "length": "100"};

    final response = await _editPropertyProvider.getAllGovernates(
      getAllGovernatesData,
    );

    response.fold((l) async {
      allGovernates.value = GetAllGovernatesModel.fromJson(l['result']);
    }, (r) => _showError(r.message));
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final uploadImageData = {"file": FileHelper.getMultiPartFile(imageFile)};

      final response = await _editPropertyProvider.uploadImage(uploadImageData);

      response.fold((l) {}, (r) => _showError(r.message));
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.primary,
      );
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColors.primary,
    );
  }

  void clearData() {
    titleController.clear();
    buildingNoController.clear();
    whatsappController.clear();
    gardenAreaController.clear();
    districtController.clear();
    streetController.clear();
    areaController.clear();
    levelController.clear();
    priceController.clear();
    descriptionController.clear();

    selectedContractType.value = 0;
    isFurnished.value = false;
    hasParking.value = false;
    hasGarden.value = false;

    rent.value = 0;
    propertyStatus.value = 0;
    selectedGovernate.value = null;
    finishing.value = 0;
    selectedRooms.value = 0;
    recieption.value = 0;
    dining.value = 0;
    balcony.value = 0;
    kitchen.value = 0;
    toilet.value = 0;
    documents.value = 0;
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // طباعة عدد الأماكن المسترجعة

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        selectedAddress.value =
            "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      } else {
        selectedAddress.value = "العنوان غير موجود";
      }
    } catch (e) {
      selectedAddress.value = "العنوان غير موجود";
    }
  }

  @override
  void onInit() {
    super.onInit();

    getAllGovernates();

    // Set initial values for TextEditingControllers
    advDetailsModel.listen((advDetails) {
      if (advDetails != null) {
        titleController.text = advDetails.title ?? '';
        buildingNoController.text = advDetails.buildingNumber ?? '';
        whatsappController.text = advDetails.secondMobileNumber ?? '';
        gardenAreaController.text = "${advDetails.gardenArea ?? ''}";
        streetWidthController.text = "${advDetails.streetWidth ?? ''}";
        districtController.text = advDetails.compound ?? '';
        streetController.text = advDetails.street ?? '';
        areaController.text = advDetails.area ?? '';
        levelController.text = "${advDetails.floorsNumber ?? ''}";
        priceController.text = "${advDetails.price ?? ''}";
        descriptionController.text = advDetails.description ?? '';
        selectedAdType.value = advDetails.type ?? 0;
        selectedContractType.value = advDetails.agreementStatus ?? 0;
        selectedGovernateId.value = advDetails.governorateId ?? 0;
        selectedMrMrs.value = advDetails.mrMrs == 1 ? "Mr" : "Mrs";
        selectedBrokerOwner.value =
            advDetails.advertiseMaker == 1 ? "Owner" : "Broker";
        selectedBuildingUsingFor.value =
            advDetails.type == 4 ? advDetails.usingFor : 0;
        imageFiles.value = List.generate(6, (index) => null);
        hasShop.value = advDetails.shop ?? false;
        buildingAreaController.text = "${advDetails.buildingArea ?? ""}";
        noShopsController.text = "${advDetails.shopsNumber ?? ''}";
        parkingSpaceController.text = "${advDetails.parkingSpace ?? ''}";
        buildingDateController.text =
            advDetails.type == 4
                ? DateFormatHelper.formatDateTime(advDetails.buildingDate ?? '')
                : "";
        buildingWidthController.text = "${advDetails.width ?? ''}";
        buildingLengthController.text = "${advDetails.length ?? ''}";
        streetWidthController.text = "${advDetails.streetWidth ?? ''}";
        isWhatsAppAvailable.value = advDetails.isWhatsApped ?? false;
        isFurnished.value = advDetails.furnished ?? false;
        hasElevator.value = advDetails.elevator ?? false;
        hasParking.value = advDetails.parking ?? false;
        hasGarden.value = advDetails.garden ?? false;
        hasPool.value = advDetails.pool ?? false;
        gardenAreaController.text = "${advDetails.gardenArea ?? ''}";
        hasWater.value = advDetails.facilitesApi?[1].isSelected ?? false;
        hasElectricity.value = advDetails.facilitesApi?[2].isSelected ?? false;
        hasInternet.value = advDetails.facilitesApi?[3].isSelected ?? false;
        hasGas.value = advDetails.facilitesApi?[4].isSelected ?? false;
        hasPhone.value = advDetails.facilitesApi?[5].isSelected ?? false;
        selectedOption.value = "${advDetails.chaletRentType ?? 0}";
        apiPhotosList.value =
            advDetails.photosList
                ?.where(
                  (url) =>
                      url !=
                      "http://backend.brokerapp.me/Resources/UploadFiles/AddPhoto.png",
                )
                .toList() ??
            [];
        currentLocation.value = Position(
          latitude: advDetails.latitude ?? 0,
          longitude: advDetails.longitude ?? 0,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        if (currentLocation.value != null) {
          getAddressFromLatLng(
            LatLng(
              currentLocation.value!.latitude,
              currentLocation.value!.longitude,
            ),
          );
        }
      }
    });
  }

  void selectAd(int index) {
    selectedAdIndex.value = index; // حفظ الفهرس المحدد
    // يمكنك إضافة أي منطق إضافي هنا بناءً على الفهرس المحدد
  }

  void selectAdType(int index) {
    selectedAdType.value = index;
  }

  void updateSelectedOption(String? value) {
    selectedOption.value = value; // تحديث الخيار المحدد
  }
}
