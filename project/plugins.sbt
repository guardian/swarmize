resolvers += "Typesafe repository" at "https://repo.typesafe.com/typesafe/releases/"

// The Play plugin
addSbtPlugin("com.typesafe.play" % "sbt-plugin" % "2.3.3")

// native packager, to create docker images
addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "0.7.4")



