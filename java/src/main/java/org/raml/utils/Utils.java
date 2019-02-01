package org.raml.utils;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;

import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Utils {
  public static String cloneTckRepo(String branch) {
    Path pathObj = Paths.get(System.getProperty("java.io.tmpdir"), "raml-tck");
    String repoDir = pathObj.toAbsolutePath().toString();
    File repo = new File(repoDir);
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

  public static String[] listRamls(String folderPath) {
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
    String[] filePaths = (String[]) manifestJson.get("filePaths");


    return filePaths;
  }

  public static void saveReport(JSONObject report, String outdir) {
    return;
  }
}
