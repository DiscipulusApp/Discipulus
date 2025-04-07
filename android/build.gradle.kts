import com.android.build.gradle.LibraryExtension
import com.android.build.gradle.AppExtension
import org.gradle.api.Project
import org.gradle.api.plugins.ExtensionAware
import org.gradle.api.Action
import java.io.File
import org.gradle.api.initialization.Settings

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: File = rootProject.layout.buildDirectory.dir("../../build").get().asFile
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: File = File(newBuildDir, project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application")) {
            val androidExtension = project.extensions.getByName("android") as AppExtension
            androidExtension.apply {
                compileSdkVersion(34)
                buildToolsVersion("34.0.0")
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        } else if (project.plugins.hasPlugin("com.android.library")) {
            val androidExtension = project.extensions.getByName("android") as LibraryExtension
            androidExtension.apply {
                compileSdkVersion(34)
                buildToolsVersion("34.0.0")
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
