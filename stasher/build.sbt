import com.typesafe.sbt.SbtNativePackager._
import NativePackagerHelper._
import play.PlayScala

name := "swarmize-stasher"

version := "0.1"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  cache,
  ws,
  "org.apache.avro" % "avro" % "1.7.6",
  "com.amazonaws" % "aws-java-sdk" % "1.8.0",
  "com.amazonaws" % "amazon-kinesis-client" % "1.0.0",
  "org.elasticsearch" % "elasticsearch" % "1.2.1",
  "org.scalatest" %% "scalatest" % "2.2.0" % "test"
)

name in Universal := "swarmize-stasher"

