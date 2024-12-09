import * as path from "path";
import { ViteUserConfig } from "vitest/config";

function resolveRunfilesPath(rootPath) {
  return path.join(
    process.env.RUNFILES,
    process.env.JS_BINARY__WORKSPACE,
    rootPath
  );
}

const userConfigShortPath = "{{USER_CONFIG_SHORT_PATH}}";
const updateSnapshots = !!process.env.VITEST_TEST__UPDATE_SNAPSHOTS;
const testRoot = path.join(
  process.env.TEST_SRCDIR!,
  process.env.TEST_WORKSPACE!
);

let testConfig: ViteUserConfig["test"] = {};
if (userConfigShortPath) {
  testConfig = (await import(resolveRunfilesPath(userConfigShortPath))).default
    .test;
}

if (updateSnapshots) {
  if (!process.env.BUILD_WORKSPACE_DIRECTORY) {
    console.error(
      "[rules_vitest]: snapshot updates must use 'bazel run', not 'bazel test'."
    );
    process.exit(1);
  }

  testConfig.resolveSnapshotPath = (testPath, extension) => {
    return path.join(
      process.env.BUILD_WORKSPACE_DIRECTORY!,
      path.dirname(path.relative(testRoot, testPath)),
      "__snapshots__",
      path.basename(testPath) + extension
    );
  };
}

export default { test: testConfig };
