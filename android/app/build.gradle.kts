plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nahrdev.broker"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // ✅ Enable desugaring
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.nahrdev.broker"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("./newBroker.keystore")  // Replace with actual keystore path
            storePassword = "123456"  // Replace with actual keystore password
            keyAlias = "newBroker"  // Replace with actual key alias
            keyPassword = "123456"  // Replace with actual key password
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false  // Disable minification
            isShrinkResources = false // Disable shrinking resources
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.firebase:firebase-analytics-ktx") // ✅ Firebase dependency example
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // ✅ Correct dependency type
    implementation("com.facebook.android:facebook-android-sdk:16.3.0")
}

// ✅ Apply Google Services plugin at the bottom (required for Firebase)
apply(plugin = "com.google.gms.google-services")