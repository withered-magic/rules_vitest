"maybe utilities"

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", _maybe = "maybe")

def maybe_http_archive(**kwargs):
    _maybe(_http_archive, **kwargs)
