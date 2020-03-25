package org.raml.utils;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.apache.commons.io.FileUtils;

import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class Utils {

  // Clones raml-tck repo branch `branch`
  public static String cloneTckRepo(String branch) {
    Path pathObj = Paths.get(System.getProperty("java.io.tmpdir"), "raml-tck");
    String repoDir = pathObj.toAbsolutePath().toString();
    File repo = new File(repoDir);
    try {
      FileUtils.deleteDirectory(repo);
    } catch (IOException e) {
      e.printStackTrace();
    }
    repo.mkdirs();
    System.out.println("Cloning raml-tck to " + repoDir);
    try {
      Git git = Git.cloneRepository()
        .setURI("https://github.com/raml-org/raml-tck")
        .setDirectory(repo)
        .setBranchesToClone(Arrays.asList("refs/heads/" + branch))
        .setBranch("refs/heads/" + branch)
        .call();
    } catch (GitAPIException e) {
      System.out.println("Failed to clone repo: " + e.getMessage());
      e.printStackTrace();
    }
    return repoDir;
  }

  // Lists RAML files in `folderPath`
  public static List<String> listRamls(String folderPath) {
    Path manifest = Paths.get(folderPath, "manifest.json");
    String manifestPath = manifest.toAbsolutePath().toString();
    JSONParser parser = new JSONParser();
    JSONObject manifestJson = new JSONObject();
    try {
      manifestJson = (JSONObject) parser.parse(new FileReader(manifestPath));
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (ParseException e) {
      e.printStackTrace();
    }
    JSONArray filePathsJson = (JSONArray) manifestJson.get("filePaths");
    List<String> filePaths = new ArrayList<String>();
    Path fpath;
    for (int i = 0; i < filePathsJson.size(); i++) {
      fpath = Paths.get(folderPath, (String) filePathsJson.get(i));
      filePaths.add(fpath.toAbsolutePath().toString());
    }
    return filePaths;
  }

  // Saves JSON report as JSON files to the `outdir` directory
  public static void saveReport(JSONObject report, String outdir) {
    String outDirPath = Paths.get(outdir).toAbsolutePath().toString();
    File outDirFile = new File(outDirPath);
    outDirFile.mkdirs();
    JSONObject parserMeta = (JSONObject) report.get("parser");
    String parserName = (String) parserMeta.get("name");
    String parserLang = (String) parserMeta.get("language");
    String fname = parserName + "_" + parserLang + ".json";
    String outFilePath = Paths.get(outDirPath, fname).toAbsolutePath().toString();
    try (FileWriter file = new FileWriter(outFilePath)) {
      file.write(report.toJSONString());
      file.flush();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return;
  }
}
