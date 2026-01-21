import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.qmc.simpleAlarm"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.qmc.simpleAlarm"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        multiDexEnabled = true
        
        ndk {
            // 选择要添加的对应 cpu 类型的 .so 库
            abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }

        // 加载 .env 文件
        val envFile = rootProject.file("../.env")
        val env = Properties()
        if (envFile.exists()) {
            env.load(FileInputStream(envFile))
        }
        
        manifestPlaceholders["JPUSH_PKGNAME"] = applicationId.toString()
        manifestPlaceholders["JPUSH_APPKEY"] = env.getProperty("JPUSH_APP_KEY") ?: "" // 从 .env 读取
        manifestPlaceholders["JPUSH_CHANNEL"] = "developer-default"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // 禁用不必要的测试任务
    tasks.whenTaskAdded {
        if (name.contains("test", ignoreCase = true) && !name.contains("debug", ignoreCase = true)) {
            enabled = false
        }
    }
}



dependencies {
    // 核心库脱糖依赖
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // 测试依赖
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    
    // 极光推送依赖
    implementation("cn.jiguang.sdk:jpush:5.6.0")  // 必选，5.0.0版本开始可以自动拉取JCore包
    implementation("cn.jiguang.sdk:joperate:2.0.2")  // 可选，集成极光分析SDK
}

flutter {
    source = "../.."
}
