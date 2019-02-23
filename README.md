# Refined Github for Safari

> Browser extension that simplifies the GitHub interface and adds useful features

This is a Safari version of [Refined GitHub](https://github.com/sindresorhus/refined-github).

## Install

[Download latest release](https://github.com/lautis/refined-github-safari/releases)

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

will build the required JS file to "Refined Gituhub Extension" directory.

Then, build Refined Github.app with

```
xcodebuild
```

The built app will be located in build/Release.

## Alternatives

This repository is not the first attempt to create a Safari version of Refined GitHub. There are at least two other similar projects:

* [Safari wrapper by @fantattitude](https://github.com/fantattitude/refined-github-safari)
* [Safari fork by @mathieudutour](https://github.com/mathieudutour/refined-github-safari)

These are implemented as Legacy Safari Extension, and not Safari App Extensions.
