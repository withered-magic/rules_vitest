import * as path from "path";
import { ViteUserConfig } from "vitest/config";

const updateSnapshots = !!process.env.VITEST_TEST__UPDATE_SNAPSHOTS;
const testConfig: ViteUserConfig["test"] = {};
const testRoot = path.join(
  process.env.TEST_SRCDIR!,
  process.env.TEST_WORKSPACE!
);

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
