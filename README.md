# homebrew-tap

Homebrew tap for [DIY Accounting Limited](https://diyaccounting.co.uk)'s command-line
tools, starting with `diya-gl`: recalculate, read and write diya-gl books from the
command line.

## Install

```
brew install diy-accounting-uk/tap/diya-gl
```

or tap once and install by name:

```
brew tap diy-accounting-uk/tap
brew install diya-gl
```

## How it stays current

`Formula/diya-gl.rb` tracks the `@diy-accounting-uk/diya-gl` npm package. An hourly
workflow checks the npm registry for a new version and commits an updated formula when
one is published.

The formula does not exist yet: it is written the first time `@diy-accounting-uk/diya-gl`
1.0.0 is published to npm.

## Licence

`diya-gl` is AGPL-3.0-only. This tap's own scripts and workflows are provided as-is.
