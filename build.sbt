import org.openurp.parent.Settings._
import org.openurp.parent.Dependencies._

ThisBuild / organization := "org.openurp.std.info"
ThisBuild / version := "0.0.1-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/std-info"),
    "scm:git@github.com:openurp/std-info.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id    = "chaostone",
    name  = "Tihua Duan",
    email = "duantihua@gmail.com",
    url   = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "OpenURP Starter"
ThisBuild / homepage := Some(url("http://openurp.github.io/std-info/index.html"))

val apiVer = "0.25.1"
val starterVer = "0.0.20"
val baseVer = "0.1.29"
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
lazy val root = (project in file("."))
  .settings()
  .aggregate(web,webapp)

lazy val web = (project in file("web"))
  .settings(
    name := "openurp-std-info-web",
    common,
    libraryDependencies ++= Seq(openurp_stater_web,openurp_std_api,beangle_serializer_text,openurp_base_tag)
  )

lazy val webapp = (project in file("webapp"))
  .enablePlugins(WarPlugin,TomcatPlugin)
  .settings(
    name := "openurp-std-info-webapp",
    common
  ).dependsOn(web)

publish / skip := true
