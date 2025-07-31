plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.flutter_crm_new"
    compileSdk = 33
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.flutter_crm_new"
        minSdk = 21
        targetSdk = 33

        // ✅ FIXED: Use project.providers to access local.properties safely
        versionCode = project.providers.gradleProperty("flutter.versionCode").getOrElse("1").toInt()
        versionName = project.providers.gradleProperty("flutter.versionName").getOrElse("1.0.0")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
