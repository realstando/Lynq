plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.expense_tracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.expense_tracker"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Simple copy tasks to fix APK location issue
tasks.register<Copy>("copyApkToFlutterLocation") {
    dependsOn("assembleDebug", "assembleRelease")
    from("build/outputs/flutter-apk")
    into(File(rootProject.projectDir.parent, "build/app/outputs/flutter-apk"))
    include("*.apk")
}

afterEvaluate {
    tasks.named("assembleDebug") {
        finalizedBy("copyApkToFlutterLocation")
    }
    
    tasks.named("assembleRelease") {
        finalizedBy("copyApkToFlutterLocation")
    }
}