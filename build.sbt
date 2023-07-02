import org.openurp.parent.Settings._
import org.openurp.parent.Dependencies._

ThisBuild / organization := "org.openurp.std.info"
ThisBuild / version := "0.0.4-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/std-info"),
    "scm:git@github.com:openurp/std-info.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "OpenURP Student Info"
ThisBuild / homepage := Some(url("http://openurp.github.io/std-info/index.html"))

val apiVer = "0.33.1"
val starterVer = "0.3.3"
val baseVer = "0.4.2"
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
lazy val root = (project in file("."))
  .settings()
  .aggregate(web, webapp)

lazy val web = (project in file("web"))
  .settings(
    name := "openurp-std-info-web",
    common,
    libraryDependencies ++= Seq(beangle_commons_core, beangle_data_orm, beangle_webmvc_core, beangle_webmvc_support),
    libraryDependencies ++= Seq(openurp_std_api, openurp_edu_api,beangle_serializer_text),
    libraryDependencies ++= Seq(openurp_stater_web, openurp_base_tag,beangle_doc_docx)
  )

lazy val webapp = (project in file("webapp"))
  .enablePlugins(WarPlugin, TomcatPlugin)
  .settings(
    name := "openurp-std-info-webapp",
    common
  ).dependsOn(web)

publish / skip := true
