# Refined GitHub for Safari

> Browser extension that simplifies the GitHub interface and adds useful features

This is a Safari version of [Refined GitHub](https://github.com/sindresorhus/refined-github).

## Install

[Download latest release](https://github.com/lautis/refined-github-safari/releases)

Or using homebrew:

```sh
brew install --cask refined-github-safari
```

After this, start the app, and enable Refined Github for Safari in Safari Extensions Preferences.

## Development

Before starting, git submodules should be checked out (`git submodule update --init`) and [Node](https://nodejs.org/en/) should be installed.

Then, install required dependencies with

```
npm install
```

After this, running

```
npm run build
```

will build the required JS file to "Refined GitHub Extension" directory.

Open Xcode and make these changes for both the application and extension targets:

- In General > Identity change the bundle identifier to reverse DNS format. Make sure the extension target has the `-extension` suffix.
- In General > Signing set your team. Xcode should take care of the provisioning profile and certificate automatically.

Then, build Refined GitHub for Safari.app with

```
xcodebuild
```

The built app will be located in build/Release.

## Git attributes

For working builds while keeping the Git repository clean, there are shell scripts to help with [Git attributes](https://git-scm.com/docs/gitattributes).

Enable this with

```
git config filter.xcode-project.clean bin/xcode-project-clean DEVELOPMENT_TEAM_ID BUNDLE_IDENTIFIER
git config filter.xcode-project.smudge bin/xcode-project-smudge DEVELOPMENT_TEAM_ID BUNDLE_IDENTIFIER
```

but replace the values with your Xcode Development Team id and bundle identifier.

## Alternatives

This repository is not the first attempt to create a Safari version of Refined GitHub. There are at least two other similar projects:

* [Safari wrapper by @fantattitude](https://github.com/fantattitude/refined-github-safari)
* [Safari fork by @mathieudutour](https://github.com/mathieudutour/refined-github-safari)

These are implemented as Legacy Safari Extension, and not Safari App Extensions.
