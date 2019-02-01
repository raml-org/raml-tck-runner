package org.raml.utils;

import org.json.JSONObject;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;

import java.util.*;
import java.io.File;


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
    }
    return repoDir;
  }

  public static String[] listRamls(String folderPath) {
    return new String[]{"a","b","c"};
  }

  public static void saveReport(JSONObject report, String outdir) {
    return;
  }
}
