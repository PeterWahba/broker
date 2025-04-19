import 'package:broker/app/config/style/app_text_styles.dart';
import 'package:broker/app/config/widgets/pop_ups/map_details.dart';
import 'package:broker/app/modules/layout/data/model/get_all_ads_for_user_model.dart'
    as user_ads;
import 'package:broker/app/modules/layout/data/model/get_user_type_response_model.dart';
import 'package:broker/app/modules/layout/data/model/user_notifications_model.dart';
import 'package:broker/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/style/app_color.dart';
import '../../../config/utils/app_utils/app_utils.dart';
import '../../../config/widgets/pop_ups/multi_map_details.dart';
import '../../../core/services/storage_service.dart';
import '../../add_property/data/models/get_all_governates_model.dart';
import '../data/model/create_favorite_response_model.dart';
import '../data/model/get_adv_details_model.dart';
import '../data/model/get_last_ads_response_model.dart';
import '../data/model/get_user_favorites_response_model.dart';
import '../data/provider/layout_provider.dart';
import 'dart:ui' as ui;

class LayoutController extends GetxController {
  final LayoutProvider _layoutProvider = LayoutProvider();

  final isLoading = false.obs;
  final getFavoritesLoading = false.obs;
  final getAdsDetailsLodaing = false.obs;
  final getAllAdvertisementForUserLoading = false.obs;
  final getUserNotificationsLodaing = false.obs;
  final count = 0.obs;
  final selectedIndex = 0.obs;
  final favorites = Rxn<GetUserFavoritesResponseModel>();
  final userData = Rxn<GetUserTypeResponseModel>();
  final allAdsModel = Rxn<AllAdsModel>();
  final filteredAds = Rxn<AllAdsModel>();
  final advDetailsModel = Rxn<GetAdvDetailsModel>(); // Make it reactive
  final getAllAdsForUserModel = Rxn<user_ads.GetAllAdsForUserModel>();
  final userNotificationsModel = Rxn<UserNotificationsModel>();
  final createFavoriteResponseModel = Rxn<CreateFavoriteResponseModel>();
  final TextEditingController userEmailController = TextEditingController(
    text: StorageService.getData("email") ?? "",
  );
  final TextEditingController nameController = TextEditingController(
    text: StorageService.getData("userName") ?? "",
  );
  final TextEditingController phoneController = TextEditingController(
    text: StorageService.getData("phoneNumber") ?? "",
  );
  final TextEditingController whatsappController = TextEditingController(
    text: StorageService.getData("whatsAppNumber") ?? "",
  );
  final RxBool isWhatsappAvailable = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> getFavorites() async {
    getFavoritesLoading.value = true;
    final getFavoritesData = {'userId': StorageService.getData("userId") ?? 0};

    final response = await _layoutProvider.getFavorites(getFavoritesData);

    response.fold((l) async {
      favorites.value = GetUserFavoritesResponseModel.fromJson(l['result']);
      getFavoritesLoading.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> changeActiveStatus(int? adId) async {
    final changeActiveStatusData = adId;

    final response = await _layoutProvider.changeActiveStatus(
      changeActiveStatusData,
    );

    response.fold((l) async {
      getAllAdvertisementForUser();
    }, (r) => _showError(r.message));
  }

  Future<void> getUserType() async {
    final getUserTypeData = {'userId': StorageService.getData("userId") ?? 0};

    final response = await _layoutProvider.getSeekerDetails(
      data: getUserTypeData,
    );

    response.fold((l) async {
      userData.value = GetUserTypeResponseModel.fromJson(l['result']);
      if (userData.value?.success == false) {
        getBrokerDetails().then((r) async {
          if (userData.value?.success == true) {
            AppUtils.brokerId = userData.value?.details?.id ?? 0;
            AppUtils.phoneNumber = userData.value?.details?.phoneNumber;
            AppUtils.userName = userData.value?.details?.name ?? "";
            AppUtils.email = userData.value?.details?.emailAddress ?? "";
            AppUtils.whatsAppNumber =
                userData.value?.details?.secondMobile ?? "";
            AppUtils.isWhatsappAvailable =
                userData.value?.details?.isWhatsApped ?? false;

            await StorageService.setData("brokerId", AppUtils.brokerId ?? 0);
            await StorageService.setData(
              "phoneNumber",
              AppUtils.phoneNumber ?? 0,
            );
            await StorageService.setData("userName", AppUtils.userName ?? "");
            await StorageService.setData(
              "whatsAppNumber",
              AppUtils.whatsAppNumber ?? "",
            );
            await StorageService.setData(
              "isWhatsApp",
              AppUtils.isWhatsappAvailable ?? false,
            );
            await StorageService.setData("email", AppUtils.email ?? false);
          } else {
            getOwnerDetails().then((r) async {
              if (userData.value?.success == true) {
                AppUtils.ownerId = userData.value?.details?.id ?? 0;
                AppUtils.phoneNumber = userData.value?.details?.phoneNumber;
                AppUtils.userName = userData.value?.details?.name ?? "";
                AppUtils.email = userData.value?.details?.emailAddress ?? "";
                AppUtils.whatsAppNumber =
                    userData.value?.details?.secondMobile ?? "";
                AppUtils.isWhatsappAvailable =
                    userData.value?.details?.isWhatsApped ?? false;

                await StorageService.setData("ownerId", AppUtils.ownerId ?? 0);
              }
              await StorageService.setData(
                "phoneNumber",
                AppUtils.phoneNumber ?? 0,
              );
              await StorageService.setData("userName", AppUtils.userName ?? "");
              await StorageService.setData(
                "whatsAppNumber",
                AppUtils.whatsAppNumber ?? "",
              );
              await StorageService.setData(
                "isWhatsApp",
                AppUtils.isWhatsappAvailable ?? false,
              );
              await StorageService.setData("email", AppUtils.email ?? false);
            });
          }
        });
      } else {
        AppUtils.seekerId = userData.value?.details?.id ?? 0;
        AppUtils.phoneNumber = userData.value?.details?.phoneNumber;
        AppUtils.userName = userData.value?.details?.name ?? "";
        AppUtils.email = userData.value?.details?.emailAddress ?? "";
        AppUtils.whatsAppNumber = userData.value?.details?.secondMobile ?? "";
        AppUtils.isWhatsappAvailable =
            userData.value?.details?.isWhatsApped ?? false;
        await StorageService.setData("seekerId", AppUtils.seekerId ?? 0);
        await StorageService.setData("phoneNumber", AppUtils.phoneNumber ?? 0);
        await StorageService.setData("userName", AppUtils.userName ?? "");
        await StorageService.setData(
          "whatsAppNumber",
          AppUtils.whatsAppNumber ?? "",
        );
        await StorageService.setData(
          "isWhatsApp",
          AppUtils.isWhatsappAvailable ?? false,
        );
        await StorageService.setData("email", AppUtils.email ?? false);
      }
    }, (r) => _showError(r.message));
  }

  Future<void> getBrokerDetails() async {
    isLoading.value = true;
    final getBrokerDetailsData = {
      'userId': StorageService.getData("userId") ?? 0,
    };

    final response = await _layoutProvider.getBrokerDetails(
      data: getBrokerDetailsData,
    );

    response.fold((l) async {
      userData.value = GetUserTypeResponseModel.fromJson(l['result']);
      if (userData.value?.success == false) {
        _showError(userData.value?.error ?? "");
      }
      isLoading.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> getOwnerDetails() async {
    isLoading.value = true;
    final getOwnerDetailsData = {
      'userId': StorageService.getData("userId") ?? 0,
    };

    final response = await _layoutProvider.getOwnerDetails(
      data: getOwnerDetailsData,
    );

    response.fold((l) async {
      userData.value = GetUserTypeResponseModel.fromJson(l['result']);
      if (userData.value?.success == false) {
        _showError(userData.value?.error ?? "");
      }
      isLoading.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> deleteFavorite(int favoriteId) async {
    final response = await _layoutProvider.deleteFavorite(favoriteId);

    response.fold((l) async {
      getFavorites();
    }, (r) => _showError(r.message));
  }

  Future<void> deleteAdvertisement(int adId) async {
    final response = await _layoutProvider.deleteAdvertisement(adId);

    response.fold((l) async {
      getAllAdvertisementForUser();
      getUserNotifications();
    }, (r) => _showError(r.message));
  }

  Future<void> deleteFavoriteByAdId(int favoriteId) async {
    final response = await _layoutProvider.deleteFavoriteByAdId(favoriteId);

    response.fold((l) async {
      // getAdvDetails( favoriteId);
      getFavorites();
      advDetailsModel.update((model) {
        model?.details?.isFavourite = false; // Update the local model
      });
    }, (r) => _showError(r.message));
  }

  Future<void> createFavorite(int advertiseId) async {
    final createFavoriteData = {
      'userId': StorageService.getData("userId") ?? 0,
      'advertisementId': advertiseId,
    };

    final response = await _layoutProvider.createFavorite(createFavoriteData);

    response.fold((l) async {
      createFavoriteResponseModel.value = CreateFavoriteResponseModel.fromJson(
        l['result'],
      );
      if (createFavoriteResponseModel.value?.success == false) {
        _showError(createFavoriteResponseModel.value?.error ?? "");
      } else {
        getFavorites();
        advDetailsModel.update((model) {
          model?.details?.isFavourite = true; // Update the local model
        });
      }
    }, (r) => _showError(r.message));
  }

  Future<void> deleteAccount() async {
    final createFavoriteData = {
      'userId': StorageService.getData("userId") ?? 0,
    };

    final response = await _layoutProvider.deleteAccount(createFavoriteData);

    response.fold((l) async {}, (r) => _showError(r.message));
  }

  Future<void> getAdvDetails(int advertiseId) async {
    getAdsDetailsLodaing.value = true;
    final getAdvDetailsData = {
      'userId':
          StorageService.getData("token") == null &&
                  StorageService.getData("userId") == null
              ? "220211"
              : StorageService.getData("userId") ?? 0,
      'advertiseId': advertiseId,
    };

    final response = await _layoutProvider.getAdvDetails(
      data: getAdvDetailsData,
    );

    response.fold((l) async {
      advDetailsModel.value = GetAdvDetailsModel.fromJson(l['result']);
      getAdsDetailsLodaing.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> getAllAdvertisementForUser() async {
    getAllAdvertisementForUserLoading.value = true;
    final getAdvDetailsData = {
      "brokerId": StorageService.getData("brokerId") ?? 0,
      "ownerId": StorageService.getData("ownerId") ?? 0,
      "seekerId": StorageService.getData("seekerId") ?? 0,
    };

    final response = await _layoutProvider.getAllAdvertisementForUser(
      data: getAdvDetailsData,
    );

    response.fold((l) async {
      getAllAdsForUserModel.value = user_ads.GetAllAdsForUserModel.fromJson(
        l['result'],
      );
      getAllAdvertisementForUserLoading.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> deleteAllByUserIdAdvertisement() async {
    getAllAdvertisementForUserLoading.value = true;
    final deleteAllByUserIdAdvertisementData = {
      "brokerId": StorageService.getData("brokerId") ?? 0,
      "ownerId": StorageService.getData("ownerId") ?? 0,
      "seekerId": StorageService.getData("seekerId") ?? 0,
    };

    final response = await _layoutProvider.deleteAllByUserIdAdvertisement(
      data: deleteAllByUserIdAdvertisementData,
    );

    response.fold((l) async {
      getAllAdvertisementForUser();
      getAllAdvertisementForUserLoading.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> getUserNotifications() async {
    getUserNotificationsLodaing.value = true;
    final getUserNotificationsData = {
      "userId": StorageService.getData("userId") ?? 0,
    };

    final response = await _layoutProvider.getUserNotifications(
      data: getUserNotificationsData,
    );

    response.fold((l) async {
      userNotificationsModel.value = UserNotificationsModel.fromJson(
        l['result'],
      );
      getUserNotificationsLodaing.value = false;
    }, (r) => _showError(r.message));
  }

  Future<void> createViewForAdvertisement(int advertiseId) async {
    final getUserNotificationsData = {
      "userId":
          StorageService.getData("token") == null &&
                  StorageService.getData("userId") == null
              ? "220211"
              : StorageService.getData("userId") ?? 0,
      "advertisementId": advertiseId,
    };

    final response = await _layoutProvider.createViewForAdvertisement(
      getUserNotificationsData,
    );

    response.fold((l) async {
      getAllAdvertisementForUser();
    }, (r) => _showError(r.message));
  }

  Future<void> sendMessage(String phone) async {
    final Uri uri = Uri.parse("https://wa.me/$phone?text=Hello from Broker");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch WhatsApp",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.primary,
      );
    }
  }

  Future<void> makeCall(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Could not place call",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.primary,
      );
    }
  }

  Future<void> getAllAdvertisement({int? index, bool? searchByFilter}) async {
    if (isLoading.value) return; // Prevent multiple calls
    isLoading.value = true;
    final getAllAdvData = {
      "type":
          searchByFilter == true
              ? selectedPropertyTypeId.value ?? {}
              : (index ?? 0) > 0
              ? (((index ?? 0) - 1) ~/ 2 + 1)
              : selectedPropertyTypeId.value ?? {},

      "governorateId": selectedGovernateId.value ?? {},
      "streetOrCompund":
          districtController.text.isNotEmpty ? districtController.text : {},
      "rooms": selectedRooms.value > 0 ? "${selectedRooms.value + 1}" : {},
      "areaFrom":
          fromAreaController.text.isNotEmpty ? fromAreaController.text : {},
      "areaTo": toAreaController.text.isNotEmpty ? toAreaController.text : {},
      "decoration": selectedFinishing.value > 0 ? selectedFinishing.value : {},
      "furnished": isFurnished.value ? isFurnished.value : {},
      "parking": withParking.value ? withParking.value : {},
      "agreementStatus":
          (index ?? 0) != 0
              ? ((index ?? 0) % 2 == 0 ? 2 : 1)
              : (selectedContractType.value) > 0
              ? (selectedContractType.value) + 1
              : {},

      "priceFrom":
          fromPriceController.text.isNotEmpty ? fromPriceController.text : {},
      "priceTo":
          toPriceController.text.isNotEmpty ? toPriceController.text : {},
    }..removeWhere(
      (key, value) => value is Map && value.isEmpty,
    ); // Remove empty entries

    final response = await _layoutProvider.getAllAdvertisement(getAllAdvData);
    // Log the full response

    response.fold((l) async {
      // Check the response here
      if (l['result'] != null && l['result']['advertisements'] != null) {
        allAdsModel.value = AllAdsModel.fromJson(l['result']);
        filteredAds.value =
            allAdsModel.value; // Initialize filteredAds with allAdsModel
        // Check length after parsing
      } else {}
      isLoading.value = false;
      initMarkers(Get.context); // Initialize markers for the initial list
    }, (r) => _showError(r.message));
  }

  var selectedGovernate = Rxn<String>();
  var selectedGovernateId = RxnInt();
  var selectedPropertyType = Rxn<String>();
  var selectedPropertyTypeId = RxnInt();
  var selectedCity = Rxn<String>();
  var selectedDistrict = Rxn<String>();
  var isFurnished = false.obs;
  var withParking = false.obs;
  var selectedFinishing = 0.obs; // 0 = Without, 1 = Half, 2 = Full
  var selectedContractType = 0.obs; // 0 = For Sell, 1 = For Rent
  var selectedRooms = 0.obs;

  final fromAreaController = TextEditingController();
  final toAreaController = TextEditingController();
  final fromPriceController = TextEditingController();
  final toPriceController = TextEditingController();
  final districtController = TextEditingController();
  final allGovernates = Rxn<GetAllGovernatesModel>();

  void resetFilters() {
    selectedPropertyType.value = null;
    selectedPropertyTypeId.value = 0;
    selectedCity.value = null;
    selectedDistrict.value = null;
    selectedGovernate.value = null;
    selectedGovernateId.value = 0;
    isFurnished.value = false;
    withParking.value = false;
    selectedFinishing.value = 0;
    selectedContractType.value = 0;
    selectedRooms.value = 0;
    fromAreaController.clear();
    toAreaController.clear();
    fromPriceController.clear();
    toPriceController.clear();
    districtController.clear();
    getAllAdvertisement(index: 0);
  }

  Rxn<Set<Marker>> markers = Rxn<Set<Marker>>({});
  void initMarkers(BuildContext? context) async {
    if (context == null) return;

    markers.value = {};
    final advertisements =
        filteredAds.value?.advertisements
            ?.where((ad) => ad.latitude != null && ad.longitude != null)
            .toList();

    for (Advertisements ad in advertisements ?? []) {
      final sameLocationAds =
          advertisements
              ?.where(
                (otherAd) =>
                    otherAd.latitude == ad.latitude &&
                    otherAd.longitude == ad.longitude,
              )
              .toList();

      final marker = Marker(
        onTap: () {
          if (Get.context != null) {
            showDialog(
              barrierDismissible: false,
              context: Get.context!,
              builder:
                  (context) =>
                      sameLocationAds != null && sameLocationAds.length > 1
                          ? MultiMapDetails(advertisements: sameLocationAds)
                          : MapDetails(advertisements: ad),
            );
          }
        },
        markerId: MarkerId(ad.id.toString()),
        position: LatLng(ad.latitude ?? 0, ad.longitude ?? 0),
        icon: await _createCustomMarker(ad.price ?? "", ad.featuredAd ?? false),
      );
      markers.value?.add(marker);
    }
    markers.refresh();
  }

  Future<BitmapDescriptor> _createCustomMarker(String text, bool prime) async {
    String assetPath =
        prime
            ? Assets
                .assetsImagesPremiumAdPin // Premium marker
            : Assets.assetsImagesNormalAdPin; // Normal marker

    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List imageData = bytes.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(imageData);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..filterQuality = FilterQuality.high;

    // ✅ Adjust size for prime markers (1.5x bigger)
    double scaleFactor = prime ? 1.5 : 1.2;
    int newWidth = (image.width * scaleFactor).toInt();
    int newHeight = (image.height * scaleFactor).toInt();

    // Draw the resized image
    Rect src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    Rect dst = Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble());
    canvas.drawImageRect(image, src, dst, paint);

    // Draw text on the scaled image
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: AppTextStyle.font12white600),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    double dx = (newWidth - textPainter.width) / 2;
    double dy = (newHeight - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(dx, dy));

    final ui.Picture picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(newWidth, newHeight);
    final ByteData? imgBytes = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (imgBytes == null) {
      throw Exception("Failed to convert image to bytes");
    }

    return BitmapDescriptor.bytes(imgBytes.buffer.asUint8List());
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColors.primary,
    );
  }

  Future<void> getAllGovernates() async {
    final getAllGovernatesData = {"start": "0", "length": "100"};

    final response = await _layoutProvider.getAllGovernates(
      getAllGovernatesData,
    );

    response.fold((l) async {
      allGovernates.value = GetAllGovernatesModel.fromJson(l['result']);
    }, (r) => _showError(r.message));
  }

  Future<String> getAddressFromLatLng(
    double? latitude,
    double? longitude,
  ) async {
    if (latitude == null || longitude == null) return "العنوان غير موجود";

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.administrativeArea}";
      }
    } catch (e) {}
    return "العنوان غير موجود";
  }

  void upadteUserData() {
    userEmailController.text = StorageService.getData("email");
    nameController.text = StorageService.getData("userName");
    phoneController.text = StorageService.getData("phoneNumber");
    whatsappController.text = StorageService.getData("whatsAppNumber");
    isWhatsappAvailable.value = StorageService.getData("isWhatsApp");
  }

  @override
  void onInit() {
    super.onInit();
    if (StorageService.getData("ownerId") == null &&
        StorageService.getData("brokerId") == null &&
        StorageService.getData("seekerId") == null &&
        StorageService.getData("userName") == null &&
        StorageService.getData("phoneNumber") == null) {
      StorageService.getData("token") == null &&
              StorageService.getData("userId") == null
          ? null
          : getUserType();
    }
    getAllGovernates();
    StorageService.getData("token") == null &&
            StorageService.getData("userId") == null
        ? getAllAdvertisement(index: 0)
        : getAllAdvertisement(index: 0).then((_) {
          getFavorites();
          getAllAdvertisementForUser();
          getUserNotifications();
          upadteUserData();
        });
  }
}
