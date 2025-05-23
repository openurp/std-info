import org.openurp.parent.Dependencies.*
import org.openurp.parent.Settings.*

ThisBuild / organization := "org.openurp.std.info"
ThisBuild / version := "0.0.16"

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

val apiVer = "0.42.0"
val starterVer = "0.3.54"
val baseVer = "0.4.48"
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
val openurp_std_core = "org.openurp.std" % "openurp-std-core" % "0.0.17"

lazy val root = (project in file("."))
  .enablePlugins(WarPlugin, TomcatPlugin)
  .settings(
    name := "openurp-std-info-webapp",
    common,
    libraryDependencies ++= Seq(openurp_stater_web),
    libraryDependencies ++= Seq(openurp_std_api, openurp_edu_api),
    libraryDependencies ++= Seq(openurp_base_tag, beangle_doc_docx, beangle_notify, openurp_std_core)
  )
