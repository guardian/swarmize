import com.typesafe.sbt.SbtNativePackager._
import NativePackagerHelper._

name := "swarmize-collector"

version := "0.1"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  cache,
  ws,
  "org.apache.avro" % "avro" % "1.7.6",
  "com.amazonaws" % "aws-java-sdk" % "1.8.0",
  "org.scalatest" %% "scalatest" % "2.2.0" % "test"
)

// deployment stuff
name in Universal := "swarmize-collector"




