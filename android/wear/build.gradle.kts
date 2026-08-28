import java.util.Properties

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
        val rawVersionCode = (project.findProperty("wearVersionCode") as? String)?.toIntOrNull()
            ?: (project.findProperty("versionCode") as? String)?.toIntOrNull()
            ?: (project.findProperty("flutter.versionCode") as? String)?.toIntOrNull()
            ?: 1
        // Wear OS builds must have a distinct versionCode (e.g. +100000 offset) from phone builds
        // so Google Play Console accepts both releases under the same applicationId.
        versionCode = if (rawVersionCode < 100000) rawVersionCode + 100000 else rawVersionCode
        versionName = (project.findProperty("versionName") as? String)
            ?: (project.findProperty("flutter.versionName") as? String)
            ?: "1.0"
    }

    // Load keystore properties from local.properties or key.properties
    val keystoreProperties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        keystoreProperties.load(localPropertiesFile.inputStream())
    }
    val keyPropertiesFile = rootProject.file("key.properties")
    if (keyPropertiesFile.exists()) {
        keystoreProperties.load(keyPropertiesFile.inputStream())
    }

    // Helper function to robustly resolve keystore location across relative paths in CI and local setups
    fun resolveKeystoreFile(rawPath: String?): File? {
        if (rawPath.isNullOrBlank()) return null
        val direct = File(rawPath)
        if (direct.isAbsolute && direct.exists()) return direct

        val candidates = listOf(
            direct,
            rootProject.file("app/$rawPath"),
            project.file("../app/$rawPath"),
            rootProject.file(rawPath),
            project.file(rawPath),
            rootProject.file("app/keystore.jks"),
            project.file("../app/keystore.jks")
        )
        return candidates.firstOrNull { it.exists() }
    }

    signingConfigs {
        create("release") {
            val ciKeystorePath = System.getenv("CM_KEYSTORE_PATH")
            val ciKeystorePassword = System.getenv("CM_KEYSTORE_PASSWORD")
            val ciKeyAlias = System.getenv("CM_KEY_ALIAS")
            val ciKeyPassword = System.getenv("CM_KEY_PASSWORD")

            val resolvedCiKeystore = resolveKeystoreFile(ciKeystorePath ?: "keystore.jks")

            if ((System.getenv("CI") == "true" || ciKeystorePassword != null) && resolvedCiKeystore != null && ciKeystorePassword != null) {
                storeFile = resolvedCiKeystore
                storePassword = ciKeystorePassword
                keyAlias = ciKeyAlias ?: "discipulus"
                keyPassword = ciKeyPassword ?: ciKeystorePassword
                println("INFO: [wear] Configured release signing from CI environment (${resolvedCiKeystore.absolutePath})")
            } else if (
                keystoreProperties.containsKey("storeFile") &&
                keystoreProperties.containsKey("storePassword") &&
                keystoreProperties.containsKey("keyAlias") &&
                keystoreProperties.containsKey("keyPassword")
            ) {
                val storePath = keystoreProperties["storeFile"] as String
                val candidateFile = resolveKeystoreFile(storePath) ?: file(storePath)
                storeFile = candidateFile
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                println("INFO: [wear] Configured release signing from properties (${candidateFile.absolutePath})")
            } else {
                println("WARNING: [wear] No release keystore configured. Falling back to debug signing for release build.")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            val releaseSigning = signingConfigs.getByName("release")
            signingConfig = if (releaseSigning.storeFile != null && releaseSigning.storeFile!!.exists()) {
                releaseSigning
            } else {
                signingConfigs.getByName("debug")
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
