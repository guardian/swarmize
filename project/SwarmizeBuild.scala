import play.PlayImport._
import sbt.Keys._
import sbt._
import com.typesafe.sbt.SbtNativePackager._


object SwarmizeBuild extends Build {
  lazy val root = sbt.Project("root", file("."))
    .aggregate(collector, stasher, submissionListener, swarmConfig)
    .settings(scalaVersion := scalaLibraryVersion)

  val scalaLibraryVersion = "2.11.1"

  val avro = "org.apache.avro" % "avro" % "1.7.6"

  val standardSettings = Seq[Setting[_]](
    scalaVersion := scalaLibraryVersion,
    scalacOptions := List("-feature", "-deprecation"),

    // generally putting dependencies in here is a bad idea, but
    // test dependencies is ok in my opion :)
    libraryDependencies ++= Seq(
      "org.scalatest" %% "scalatest" % "2.2.0" % "test",

      // and joda we need everywhere!
      "org.joda" % "joda-convert" % "1.6" % "provided",
      "joda-time" % "joda-time" % "2.3"
    )
  )

  lazy val swarmConfig = sbt.Project("swarm-config", file("swarm-config"))
    .settings(standardSettings: _*)
    .settings(
      libraryDependencies ++= Seq(
        avro
      )
    )

  lazy val collector = Project("collector", file("collector")).enablePlugins(play.PlayScala)
    .dependsOn(swarmConfig)
    .settings(standardSettings: _*)
    .settings(
      libraryDependencies ++= Seq(
        cache,
        ws,
        avro,
        "com.amazonaws" % "aws-java-sdk" % "1.8.0"
      ),

      // deployment stuff
      name in Universal := "swarmize-collector"
    )

  lazy val stasher = Project("stasher", file("stasher")).enablePlugins(play.PlayScala)
    .settings(standardSettings: _*)
    .settings(

      libraryDependencies ++= Seq(
        cache,
        ws,
        avro,
        "com.amazonaws" % "aws-java-sdk" % "1.8.0",
        "com.amazonaws" % "amazon-kinesis-client" % "1.0.0",
        "org.elasticsearch" % "elasticsearch" % "1.2.1"
      ),

      name in Universal := "swarmize-stasher"
    )


  lazy val submissionListener = Project("submission-listener", file("submission-listener"))
    .settings(standardSettings: _*)
    .settings(
      libraryDependencies ++= Seq(
        "com.amazonaws" % "aws-java-sdk" % "1.8.0",
        "com.amazonaws" % "amazon-kinesis-client" % "1.0.0",
        avro
      )
    )
}