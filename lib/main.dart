import 'package:broker/app/config/style/app_theme.dart';
import 'package:broker/app/core/binding/initial_binding.dart';
import 'package:broker/app/core/heplers/app_check_internet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';

import 'app/core/heplers/localization_helper.dart';
import 'app/core/services/storage_service.dart';
import 'app/routes/app_pages.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final facebookAppEvents = FacebookAppEvents();

  // Log app launch event
  facebookAppEvents.logEvent(
    name: 'app_launch',
    parameters: {
      'launch_time': DateTime.now().toIso8601String(),
    },
  );

  await GetStorage.init(); 
  await ScreenUtil.ensureScreenSize();
  await Connectivity().checkConnectivity();

  final savedLanguage =
      StorageService.getData<String>('selected_language') ?? 'ar';

  LocalizationHelper().changeLocale(
    savedLanguage == 'ar' ? Language.arabic : Language.english,
  );

  runApp(
    Builder(
      builder: (context) {
        ScreenUtil.init(context);

        return ScreenUtilInit(
          designSize: const Size(375, 812),
          splitScreenMode: true,
          minTextAdapt: true,
          enableScaleText: () => false,
          enableScaleWH: () => false,
          builder:
              (_, child) => OKToast(
                child: AppCheckInternetBuilder(
                  child: GetMaterialApp(
                    locale: LocalizationHelper().initialLocale,
                    translations: LocalizationHelper(),
                    initialBinding: InitialBinding(),
                    theme: appTheme,
                    debugShowCheckedModeBanner: false,
                    title: "Broker",
                    initialRoute: Routes.splash,
                    getPages: AppPages.routes,
                  ),
                ),
              ),
        );
      },
    ),
  );
}