"Public API re-exports"

load("@aspect_bazel_lib//lib:directory_path.bzl", "directory_path")
load("//vitest/private:vitest_test_rule.bzl", vitest_test_rule = "vitest_test")

def vitest_test(
        name,
        node_modules,
        snapshots = True,
        base_dir = None,
        **kwargs):
    # type: (string, string, bool, string | None, Unknown) -> None
    """vitest_test rule

    Args:
        name: A unique name for this target.
        node_modules: Label pointing to the linked node_modules target where vitest is linked.
        snapshots: If True, create a `{name}_update_snapshots` that will update all `__snapshots__` directories on `bazel run`.
        base_dir: Base directory for test discovery, relative to the workspace root.
        **kwargs: Additional attributes.
    """
    entry_point = "_{}_vitest_entrypoint".format(name)
    directory_path(
        name = entry_point,
        directory = "{}/vitest/dir".format(node_modules),
        path = "vitest.mjs",
    )

    data = kwargs.pop("data", [])  # type: list[string]
    data.append("{}/vitest".format(node_modules))
    data.extend(native.glob(["__snapshots__/**"]))

    tags = kwargs.pop("tags", [])  # type: list[string]

    if not base_dir:
        base_dir = native.package_name()

    vitest_test_rule(
        name = name,
        data = data,
        base_dir = base_dir,
        entry_point = entry_point,
        enable_runfiles = select({
            "@aspect_bazel_lib//lib:enable_runfiles": True,
            "//conditions:default": False,
        }),
        tags = tags,
        **kwargs
    )

    if snapshots:
        vitest_test_rule(
            name = name + "_update_snapshots",
            data = data,
            base_dir = base_dir,
            entry_point = entry_point,
            enable_runfiles = select({
                "@aspect_bazel_lib//lib:enable_runfiles": True,
                "//conditions:default": False,
            }),
            update_snapshots = True,
            tags = tags + ["manual"],
            **kwargs
        )
