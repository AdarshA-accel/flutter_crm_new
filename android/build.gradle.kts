import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// ✅ Shared repositories for all modules
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Set custom build directory for the entire project
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // ✅ Set custom build directory for each subproject
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    layout.buildDirectory.set(newSubprojectBuildDir)

    // ✅ Ensure all subprojects wait for evaluation of :app
    evaluationDependsOn(":app")
}

// ✅ Task to clean the custom build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
