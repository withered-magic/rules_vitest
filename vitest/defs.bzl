"Public API re-exports"

load("@aspect_bazel_lib//lib:directory_path.bzl", "directory_path")
load("//vitest/private:vitest_test.bzl", vitest_test_rule = "vitest_test")

def vitest_test(
        name,
        node_modules):
    # type: (string, string) -> None
    """vitest_test rule

    Args:
        name: A unique name for this target.
        node_modules: Label pointing to the linked node_modules target where vitest is linked.
    """
    entry_point = "_{}_vitest_entrypoint".format(name)
    directory_path(
        name = entry_point,
        directory = "{}/vitest/dir".format(node_modules),
        path = "vitest.mjs",
    )

    vitest_test_rule(
        name = name,
        entry_point = entry_point,
    )
