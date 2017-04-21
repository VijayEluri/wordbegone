import sbt._

object Test {
  def apply() = Seq(
      "org.scalatest" %% "scalatest" % "3.0.1" % "test"
    )
}

object App {
  def apply() = Seq(
    "net.sourceforge.saxon" % "saxon" % "9.1.0.8",
    "org.fusesource.wikitext" % "textile-core" % "1.4",
    "org.fusesource.wikitext" % "wikitext-core" % "1.4",
    "commons-cli" % "commons-cli" % "1.2",
    "org.codehaus.groovy" % "groovy-all" % "2.4.10",
    "net.sourceforge.nekohtml" % "nekohtml" % "1.9.22",
    "org.apache.ant" % "ant" % "1.9.4",
    "commons-lang" % "commons-lang" % "2.6"
  )
}
