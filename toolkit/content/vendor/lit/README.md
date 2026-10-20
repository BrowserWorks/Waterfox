# Vendoring for lit

[lit](https://lit.dev/) can be used to help create Web Components.

## The lit.all.mjs bundle

The lit package is imported in a vendoring step and the contents are extracted
into the lit.all.mjs file. This has some differences from using lit in a regular
npm project. Imports that would normally be into a specific file are pulled
directly from the lit.all.mjs file.

eg.

```js
// Standard npm package:
import { LitElement } from "lit";
import { classMap } from "lit/directives/class-map.js";

// Using lit.all.mjs (pathing to lit.all.mjs may differ)
import { classMap, LitElement } from "../vendor/lit.all.mjs";
```

## To update the lit bundle

Vendoring runs off of the latest tag in the https://github.com/lit/lit repo. If
the latest tag is a lit@ tag then running the vendor command will update to that
version. If the latest tag isn't for lit@, you may need to bundle manually. See
the moz.yaml file for instructions.

### Using mach vendor

```sh
./mach vendor toolkit/content/vendor/lit/moz.yaml
git commit -am "Update to lit@<version>"
```

### Manually updating the bundle

To manually update, you'll need to checkout a copy of lit/lit. First we apply
our patches to the last version we imported:

```sh
# Examples assume you have some root folder like this with lit and firefox
export PROJECTS_ROOT=~/Projects
cd "$PROJECTS_ROOT"
git clone https://github.com/lit/lit
cd lit
git checkout lit@<last-version>
git am "$PROJECTS_ROOT"/firefox/toolkit/content/vendor/lit/*.patch
npm ci && npm run build
```

This should build our version of Lit from the last release we were using. Since
we previously build off this tag, the build should be successful. Now we can
rebase onto the new version with `git rebase lit@<new-version>`. Resolve any
conflicts as necessary. If you need to make updates to the patches, make commits
as usual in a git repo. If you're revising an existing patch then amend it. New
commits can be authored as well.

```sh
git rebase lit@<new-version>
# Resolve any conflicts
# Amend or make new patches if necessary
# Verify it builds
npm ci && npm run build
# Export the new patches.
git format-patch lit@<last-version>
rm  "$PROJECTS_ROOT"/firefox/toolkit/content/vendor/lit/*.patch
mv -f *.patch "$PROJECTS_ROOT"/firefox/toolkit/content/vendor/lit/
# Commit the updated patches to firefox
cd "$PROJECTS_ROOT"/firefox
git commit -am "Update Lit patches to lit@<version>"
# Build and commit the new Lit bundle in firefox
./mach vendor toolkit/content/vendor/lit/moz.yaml
git commit -am "Update Lit to lit@<version>"
```

## The lit.all.d.ts file

The [lit](https://github.com/lit/lit) npm package is installed *only for its types*, which are exported from a custom [lit.all.d.ts](/toolkit/content/widgets/vendor/lit.all.d.ts) file. This file contains all of Lit's types used throughout the project and using it is preferred vs importing types from each of Lit's files directly, mainly to avoid having to update paths in so many places if their paths in the Lit project ever change. The file doesn't have every exported Lit type by default. Any Lit type that is necessary in the project will need to be explicitly added and re-exported from this file.
