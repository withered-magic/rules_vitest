<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="vitest_test"></a>

## vitest_test

<pre>
vitest_test(<a href="#vitest_test-name">name</a>, <a href="#vitest_test-node_modules">node_modules</a>, <a href="#vitest_test-snapshots">snapshots</a>, <a href="#vitest_test-kwargs">kwargs</a>)
</pre>

vitest_test rule

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="vitest_test-name"></a>name |  A unique name for this target.   |  none |
| <a id="vitest_test-node_modules"></a>node_modules |  Label pointing to the linked node_modules target where vitest is linked.   |  none |
| <a id="vitest_test-snapshots"></a>snapshots |  If True, create a <code>{name}_update_snapshots</code> that will update all <code>__snapshots__</code> directories on <code>bazel run</code>.   |  <code>True</code> |
| <a id="vitest_test-kwargs"></a>kwargs |  Additional attributes.   |  none |


