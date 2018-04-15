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

will build the extension files to "Refined Gituhub.safariextension" directory. This directory can be loaded with [Extension Builder](https://developer.apple.com/library/content/documentation/Tools/Conceptual/SafariExtensionGuide/UsingExtensionBuilder/UsingExtensionBuilder.html) to Safari.

## Alternatives

This repository is not the first attempt to create a Safari version of Refined GitHub. There are at least two other similar projects:

* [Safari wrapper by @fantattitude](https://github.com/fantattitude/refined-github-safari) - last updated in 2016
* [Safari fork by @mathieudutour](https://github.com/mathieudutour/refined-github-safari) - almost up to date, but conflicts make it hard to maintaint it
