package org.raml.runner;

import org.raml.parsers.IParser;
import org.raml.parsers.WebApiParser;
// import org.raml.parsers.RamlJavaParser;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

@Command(name = "raml-tck-runner", mixinStandardHelpOptions = true, version = "1.0.0")
public class RamlTckRunner implements Runnable {
  @Option(names = "--parser", description = "name of a parser to run")
  String parserName;

  @Option(names = "--outdir", description = "output JSON report directory")
  String outdir = "./";

  @Option(names = "--branch", description = "raml-tck branch to load RAML files from")
  String branch;

  public void run() {
    // test
    System.out.println("Parse: " + parserName);
    System.out.println("Outdir: " + outdir);
    System.out.println("Branch: " + branch);

    IParser parser;
    try {
      parser = new WebApiParser();
      parser.parse("asd");
    } catch (Exception ex) {

    }
  }

  public static void main(String[] args) {
    CommandLine.run(new RamlTckRunner(), args);
  }
}
