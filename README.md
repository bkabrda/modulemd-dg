# Example of modulemd with distgen

Files in the repo:
* `dg-multispec.yaml` - a file with values for distgen
* `Makefile` - a very simple `Makefile` that can generate `module.yaml` using distgen
* `module.in` - templated modulemd file

## dg-multispec.yaml
The "multispec" file basically lists "dimensions" of "rendering matrix" (see below) and associated values that can be used for rendering.

* Contains `version` (currently always `1`) and `specs`.
* `specs` contain `distroinfo` and `userspace` - these are called "spec groups"; each "spec group" contains named "specs" (in our case these are `fedora` from `distroinfo`, `fancy` and `nonfancy` from `userspace`.
* The `distroinfo` spec group is mandatory and has to contain at least one spec; additionally, each of its member specs must contain `distros` list (hence limiting set of distros that we can render for).
* Any other "spec groups" (in our case just `userspace`) are optional and their member specs can contain any values you wish.
* "Spec groups" and are the "dimensions" of the "rendering matrix", IOW carthesian product of "`distroinfo.distro` specs * `userspace` specs" is a list of all posibilities for which the target file can be rendered. Note that the `distroinfo` member specs are treated differently, as we take their `.distros` listto be part of the matrix dimensions; for other "spec groups", we take their members.
* Each "spec" contains useful values, e.g. `distroinfo.fedora.distroletter` or `userspace.{fancy,nonfancy}.shared_userspace`.

## Makefile

A simple Makefile that demonstrates usage of distgen to generate. You can pass it another `DISTRO` or `USERSPACE` to render `module.yaml` for different combination. Example distgen invocation by the Makefile:

```
/usr/bin/dg --distro fedora-27-x86_64.yaml --multispec dg-multispec.yaml --multispec-selector userspace=nonfancy --template module.in --output module.yaml
```

Noticable things for distgen invocation:
* `--distro` - has to be one of distgen-shipped distros, see `/usr/share/distgen/distconf/` for list of included distros (alternatively you can provide your own); this also selects the correct `distroinfo` member from multispec
* `--multispec` - pass path to the multispec file
* `--multispec-selector` - selects a desired "spec" from a "spec group"; has to be used for every "spec group" except `distroinfo`, which is automatically selected by `--distro`
* `--output` - output name for the rendered file

You can pass `DISTRO` and `USERSPACE` vars to Makefile to render a different combination, e.g.:

```
make USERSPACE=fancy DISTRO=fedora-28-x86_64 module.yaml
```

## module.in

Template for `module.yaml`. Noticable things:

* The values from selected "specs" from multispec file are accessible under `{{ spec.<name> }}`, e.g. `{{ spec.distroletter }}`, {{ spec.shared_userspace }}`.
* The values from distro config are accessible under `{{ config.<name> }}`, e.g. `{{ config.os.version }}`.
