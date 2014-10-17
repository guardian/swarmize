import play.PlayImport._
import sbt.Keys._
import sbt._
import com.typesafe.sbt.SbtNativePackager._
import NativePackagerKeys._


object SwarmizeBuild extends Build {
  lazy val root = sbt.Project("root", file("."))
    .aggregate(collector, processor, api, sharedLib)
    .settings(scalaVersion := scalaLibraryVersion)

  val scalaLibraryVersion = "2.11.2"

  val aws = "com.amazonaws" % "aws-java-sdk" % "1.8.7"

  val standardSettings = Seq[Setting[_]](
    scalaVersion := scalaLibraryVersion,
    scalacOptions := List("-feature", "-deprecation"),

    // generally putting dependencies in here is a bad idea, but
    // test dependencies is ok in my opion :)
    libraryDependencies ++= Seq(
      "org.scalatest" %% "scalatest" % "2.2.2" % "test",

      // and joda we need everywhere!
      "org.joda" % "joda-convert" % "1.7" % "provided",
      "joda-time" % "joda-time" % "2.4"
    ),

    resolvers += "Typesafe repository" at "https://repo.typesafe.com/typesafe/releases/",

    // Don't include documentation in artifact
    doc in Compile <<= target.map(_ / "none"),

    maintainer in Docker := "Graham Tackley <graham.tackley@theguardian.com>",

    dockerExposedPorts in Docker := List(9000)

  )

  lazy val sharedLib = sbt.Project("shared-lib", file("shared-lib"))
    .settings(standardSettings: _*)
    .settings(
      libraryDependencies ++= Seq(
        "com.typesafe.play" %% "play" % play.core.PlayVersion.current,
        "com.google.guava" % "guava" % "18.0",
        "com.google.code.findbugs" % "jsr305" % "3.0.0",
        aws
      )
    )

  lazy val collector = Project("collector", file("collector")).enablePlugins(play.PlayScala)
    .dependsOn(sharedLib)
    .settings(standardSettings: _*)
    .settings(
      libraryDependencies ++= Seq(
        ws,
        aws
      ),

      // deployment stuff
      name in Universal := "swarmize-collector"
    )

  lazy val processor = Project("processor", file("processor")).enablePlugins(play.PlayScala)
    .dependsOn(sharedLib)
    .settings(standardSettings: _*)
    .settings(

      libraryDependencies ++= Seq(
        ws,
        aws,
        "org.elasticsearch" % "elasticsearch" % "1.2.1"
      ),

      name in Universal := "swarmize-processor"
    )


  lazy val api = Project("api", file("api-scala")).enablePlugins(play.PlayScala)
    .dependsOn(sharedLib)
    .settings(standardSettings: _*)
    .settings(

      libraryDependencies ++= Seq(
        ws,
        aws,
        "org.elasticsearch" % "elasticsearch" % "1.2.1"
      ),

      name in Universal := "swarmize-api"
    )
}