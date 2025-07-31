pluginManagement {
    val flutterSdkPath: String = run {
        val properties = java.util.Properties()
        file("../local.properties").inputStream().use { properties.load(it) }
        val path = properties.getProperty("flutter.sdk")
        require(!path.isNullOrBlank()) { "flutter.sdk not set in local.properties" }
        path
    }

    // ✅ Include Flutter's Gradle tools
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// ✅ Declare plugins and prevent double apply
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// ✅ Include your app module
include(":app")
