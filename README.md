# homebrew-diya-gl

Homebrew tap for [DIY Accounting Limited](https://diyaccounting.co.uk)'s command-line
tools, starting with `diya-gl`: recalculate, read and write diya-gl books from the
command line.

## Install

```
brew install diy-accounting-uk/diya-gl/diya-gl
```

or tap once and install by name:

```
brew tap diy-accounting-uk/diya-gl
brew install diya-gl
```

## How it stays current

`Formula/diya-gl.rb` tracks the `@diy-accounting-uk/diya-gl` npm package. An hourly
workflow checks the npm registry for a new version and commits an updated formula when
one is published.

## Licence

This tap's own scripts and workflows are Apache-2.0, see `LICENSE`. The formula installs
`diya-gl`, and states that package's own licence, which the formula reads from the npm
registry rather than assuming: Apache-2.0 from `diya-gl` 1.1.0 onward.
