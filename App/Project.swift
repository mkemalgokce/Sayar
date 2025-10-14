import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "Sayar",
    dependencies: SharedModule.all + FeatureModule.all + DependencyGroup.firebaseAll
)
