import NativePackagerHelper._

lazy val root = (project in file(".")).
  enablePlugins(JavaAppPackaging).
  settings(
    inThisBuild(List(
      organization := "org.northrop.leanne",
      scalaVersion := "2.12.1",
      version      := "0.1.0-SNAPSHOT"
    )),
    name := "publisher",
    libraryDependencies ++= App() ++ Test(),
    packageOptions += Package.ManifestAttributes(
      "Class-Path" -> "*.jar"
    ),
    mappings in Universal += file("src/dist/bin/app.icns") -> "app.icns",
    mappings in Universal <++= sourceDirectory map (src => directory(src / "dist" / "input")),
    mappings in Universal <++= sourceDirectory map (src => directory(src / "dist" / "resources")),
    mappings in (Compile, packageDoc) := Seq(),
    javaOptions in Universal ++= Seq(
      s"-Xdock:name=Publisher",
      "-Xdock:icon=app.icns",
      s"-Dprogram.name=Publisher",
      "-Dpub.home=../"
    )
  )
