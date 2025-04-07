import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.harrydekat.discipulus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" //flutter.ndkVersion

    compileOptions {
        // Enable core library desugaring
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.harrydekat.discipulus"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24 //flutter.minSdkVersion
        targetSdk = 34 //flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Load keystore properties from local.properties
    val keystorePropertiesFile: File = rootProject.file("local.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(keystorePropertiesFile.inputStream())
    }

    signingConfigs {
        create("release") {
            if (System.getenv("CI") == "true") { // CI=true is exported by Codemagic
                storeFile = file(System.getenv("CM_KEYSTORE_PATH"))
                storePassword = System.getenv("CM_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("CM_KEY_ALIAS")
                keyPassword = System.getenv("CM_KEY_PASSWORD")
            } else {
                // Load from local.properties
                if (keystoreProperties.containsKey("storeFile") &&
                    keystoreProperties.containsKey("storePassword") &&
                    keystoreProperties.containsKey("keyAlias") &&
                    keystoreProperties.containsKey("keyPassword")
                ) {
                    storeFile = file(keystoreProperties["storeFile"] as String)
                    storePassword = keystoreProperties["storePassword"] as String
                    keyAlias = keystoreProperties["keyAlias"] as String
                    keyPassword = keystoreProperties["keyPassword"] as String
                } else {
                    println("WARNING: local.properties is missing keystore information. Release builds will not be signed.")
                }
            }
        }
    }

    buildTypes {
        release {
            // Use the release signing config
            signingConfig = if (System.getenv("CI") == "true") signingConfigs.getByName("release") else signingConfigs.getByName("debug")
            // You can add other release-specific settings here, like minification
            isMinifyEnabled = true
            
        }
    }
}

configurations.all {
    resolutionStrategy {
        force("androidx.work:work-runtime:2.8.1")
        force("androidx.work:work-runtime-ktx:2.8.1")
    }
}

dependencies {
    // Add the core library desugaring dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
