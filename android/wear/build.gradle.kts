plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "dev.harrydekat.discipulus.wear"
    compileSdk = 36

    defaultConfig {
        applicationId = "dev.harrydekat.discipulus"
        minSdk = 28
        targetSdk = 36
        versionCode = (project.findProperty("versionCode") as? String)?.toIntOrNull()
            ?: (project.findProperty("flutter.versionCode") as? String)?.toIntOrNull()
            ?: 1
        versionName = (project.findProperty("versionName") as? String)
            ?: (project.findProperty("flutter.versionName") as? String)
            ?: "1.0"
    }

    signingConfigs {
        create("release") {
            val keystorePath = System.getenv("CM_KEYSTORE_PATH") ?: "../app/keystore.jks"
            val keystorePassword = System.getenv("CM_KEYSTORE_PASSWORD")
            val keyAlias = System.getenv("CM_KEY_ALIAS")
            val keyPassword = System.getenv("CM_KEY_PASSWORD")

            if (file(keystorePath).exists() && keystorePassword != null) {
                storeFile = file(keystorePath)
                storePassword = keystorePassword
                this.keyAlias = keyAlias
                this.keyPassword = keyPassword
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            val releaseSigning = signingConfigs.getByName("release")
            if (releaseSigning.storeFile != null) {
                signingConfig = releaseSigning
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    buildFeatures {
        compose = true
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("com.google.android.gms:play-services-wearable:18.2.0")
    implementation("androidx.wear.watchface:watchface-complications-data-source-ktx:1.2.1")

    implementation("androidx.activity:activity-compose:1.9.0")
    implementation("androidx.compose.ui:ui:1.6.8")
    implementation("androidx.compose.material:material-icons-extended:1.6.8")
    implementation("androidx.wear.compose:compose-material3:1.0.0-alpha27")
    implementation("androidx.wear.compose:compose-foundation:1.3.1")
    implementation("androidx.wear.compose:compose-navigation:1.3.1")
    implementation("androidx.compose.foundation:foundation:1.6.8")
    implementation("androidx.compose.ui:ui-tooling-preview:1.6.8")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")

    debugImplementation("androidx.compose.ui:ui-tooling:1.6.8")
}
