import org.beangle.tools.sbt.Sas
import org.openurp.parent.Settings._
import org.openurp.parent.Dependencies._

ThisBuild / organization := "org.openurp.std"
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

val apiVer = "0.24.0"
val starterVer = "0.0.15"
val baseVer = "0.1.24"
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
lazy val root = (project in file("."))
  .settings()
  .aggregate(adminapp,studentapp)

lazy val adminapp = (project in file("adminapp"))
  .enablePlugins(WarPlugin)
  .settings(
    name := "openurp-std-info-adminapp",
    common,
    libraryDependencies ++= Seq(openurp_stater_web,openurp_std_api,beangle_serializer_text,openurp_base_tag),
    libraryDependencies ++= Seq(Sas.Tomcat % "test")
  )
lazy val studentapp = (project in file("studentapp"))
  .enablePlugins(WarPlugin)
  .settings(
    name := "openurp-std-info-studentapp",
    common,
    libraryDependencies ++= Seq(openurp_stater_web,openurp_std_api,beangle_serializer_text,openurp_base_tag),
    libraryDependencies ++= Seq(Sas.Tomcat % "test")
  )

publish / skip := true
