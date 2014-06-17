libraryDependencies += "org.apache.avro" % "avro" % "1.7.6"

seq( sbtavro.SbtAvro.avroSettings: _*)

stringType in avroConfig := "String"

version in avroConfig := "1.7.6"


