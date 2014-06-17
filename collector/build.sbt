seq( sbtavro.SbtAvro.avroSettings: _*)

name := "swarmize-collector"

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  cache,
  ws,
  "org.apache.avro" % "avro" % "1.7.6"
)

stringType in avroConfig := "String"

version in avroConfig := "1.7.6"


