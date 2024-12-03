"Implementation details for the vitest_test rule"

load("@aspect_bazel_lib//lib:copy_to_bin.bzl", "copy_file_to_bin_action")
load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

_attrs = dicts.add(js_binary_lib.attrs, {
    "config": attr.label(
        # Supported file extensions according to https://vitest.dev/guide/#configuring-vitest
        allow_single_file = [".js", ".mjs", ".cjs", ".ts", ".cts", ".mts"],
    ),
    "entry_point": attr.label(
        mandatory = True,
    ),
})

def _vitest_test_impl(ctx):
    # type: (ctx) -> Unknown
    providers = []
    user_config = copy_file_to_bin_action(ctx, ctx.file.config) if ctx.attr.config else None

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "rules_vitest",
        log_prefix_rule = "vitest_test",
        fixed_args = ["run"],
    )

    files = ctx.files.data[:]
    if user_config:
        files.append(user_config)

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = js_lib_helpers.gather_files_from_js_infos(
            targets = ctx.attr.data + [ctx.attr.config] if ctx.attr.config else ctx.attr.data,
            include_sources = ctx.attr.include_sources,
            include_types = ctx.attr.include_types,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_transitive_types = ctx.attr.include_transitive_types,
            include_npm_sources = ctx.attr.include_npm_sources,
        ),
    ).merge(launcher.runfiles).merge_all([
        target[DefaultInfo].default_runfiles
        for target in ctx.attr.data
    ])

    providers.append(
        DefaultInfo(
            executable = launcher.executable,
            runfiles = runfiles,
        ),
    )

    return providers

lib = struct(
    attrs = _attrs,
    implementation = _vitest_test_impl,
)

vitest_test = rule(
    implementation = lib.implementation,
    attrs = lib.attrs,
    toolchains = js_binary_lib.toolchains,
    test = True,
)
