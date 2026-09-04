# rm-docs-theme

The shared Jekyll theme for the [reidmorrison.com](https://reidmorrison.com)
documentation sites. One palette, one type pairing, one syntax sheet, one
sidebar, across every gem's `docs/` folder.

## Previewing

**A real doc site, against this working copy of the theme:**

```bash
bin/preview ~/src/semantic_logger/docs
```

Use this while converting a site, and while changing the theme. It is the only
way to see a site rendered before this repo is public: a converted site's
`_config.yml` names `remote_theme: reidmorrison/rm-docs-theme@v1`, and that tag
does not resolve until this repo is pushed and tagged. Running plain `jekyll
serve` against a converted site before then produces `Layout 'default' requested
in api.md does not exist` and an unstyled page.

The script pins its own `Gemfile`, resolves the theme as a path gem, and layers
`preview/overlay.yml` over the site's config to swap `remote_theme` for a local
`theme`. That exercises the real Jekyll theme layering, including a site's
`_includes` winning over the theme's, which copying files into the site would
not prove. It builds into `preview/_site` so it never writes into the site's
repo. Pass any Jekyll option through: `bin/preview ~/src/iostreams/docs --port 4001`.

Jekyll watches the site, not the theme, so a theme edit needs a restart.

**The theme's own specimen page:**

```bash
bundle install
bundle exec jekyll serve
```

`index.md` carries one instance of everything the theme styles, set in real
Semantic Logger and Symmetric Encryption configuration. Look at it in both light
and dark before shipping a change. Headless Chrome defaults to dark, so force
the one you mean with a `data-theme` stamp on `<html>`.

## Why a remote theme

Every consuming site is built by the classic GitHub Pages builder from a `docs/`
folder. `jekyll-remote-theme` ships inside the `github-pages` gem those sites
already run, so adopting this theme needs **no Actions workflow, no Gemfile
change and no gem release**. A site names a tag; GitHub fetches it at build
time.

The alternative was six vendored copies, which is what existed before: five of
the seven files in each `docs/stylesheets/` were byte-identical across all six
repos, and the one that was not had a mobile-header fix in `symmetric-encryption`
that the other five never received.

## Adopting the theme

Four steps in a gem repo.

**1. Delete the vendored copies.**

```bash
git rm -r docs/_layouts docs/stylesheets docs/javascripts
```

`docs/images/` stays: favicons and any figures a page links are the site's own.

**2. Point `docs/_config.yml` at the theme and describe the project.**

```yaml
remote_theme: reidmorrison/rm-docs-theme@v1

# GitHub Pages enables jekyll-remote-theme on its own, but a local
# `bundle exec jekyll build` does not: Jekyll only auto-requires gems in the
# :jekyll_plugins bundler group. Without this line a local build silently
# skips the theme and reports "Layout 'default' does not exist".
plugins:
  - jekyll-remote-theme

markdown: kramdown
kramdown:
  toc_levels: "2..3"

project:
  name:     Semantic Logger
  tagline:  Structured logs. Better decisions.
  github:   reidmorrison/semantic_logger
  gem:      semantic_logger
  license:  Apache 2.0 License
  description: >-
    High-performance, asynchronous structured logging for Ruby and Rails.

nav:
  - group: Start here
    items:
      - { page: index.html,     label: Overview }
      - { page: api.html,       label: Guide }
  - group: Configuration
    items:
      - { page: config.html,    label: Configuration }
      - { page: appenders.html, label: Appenders }
```

Pin a tag, not a branch. See "Releases" for what `@v1` means.

**3. Add the project mark, if it has one.**

Drop an inline SVG at `docs/_includes/logo.svg`. It overrides the theme's
default shield, because Jekyll searches a site's `_includes` before the theme's.
Two requirements:

- It must be **inline SVG, not an `<img>`**. Its fills read the `--logo-ink` and
  `--logo-accent` custom properties so one file serves both themes, and an
  externally referenced SVG cannot see the page's CSS.
- It must carry `class="brand-mark"` and `aria-hidden="true"`.

If the project's identity is an **illustration rather than a monogram**, set
`project.mark_image: images/whatever.png` in `_config.yml` instead and skip the
SVG. The theme then renders an `<img>`. A detailed full-colour drawing does not
reduce to two flat fills, so the custom-property trick has nothing to work with.
The tradeoff: such a mark cannot respond to the theme, so **check it against
both grounds** before shipping one. Rocket Job's rocket is the case this exists
for.

**4. Remove the hero image from `index.md`, if there is one.**

The theme has no hero slot. The masthead mark is the identity.

## Configuration reference

### `project`

| Key | Required | What it does |
|---|---|---|
| `name` | yes | Wordmark, `<title>` suffix, footer |
| `tagline` | no | Mono caps line under the wordmark |
| `description` | no | Default `<meta name="description">` and Open Graph description |
| `seo_title` | no | Overrides the home page `<title>`; defaults to `name · tagline` |
| `github` | no | `owner/repo`. Renders the GitHub, Source and Issues links |
| `gem` | no | Gem name. Renders the RubyGems link |
| `license` | no | Footer text. Defaults to `Apache 2.0 License` |
| `links` | no | Extra masthead links: a list of `{ label:, url: }` |
| `mark_image` | no | Path to a raster mark, used instead of `_includes/logo.svg`. For illustrations that cannot be two flat fills |
| `extra_css` | no | Path to a site-local stylesheet, loaded last |
| `feed` | no | Truthy to advertise `/feed.xml` |

### `nav`

Grouped, for a site with enough pages to have sections:

```yaml
nav:
  - group: Start here
    items:
      - { page: index.html, label: Overview }
```

Or flat, for a small site where grouping six pages would be ceremony:

```yaml
nav:
  - { page: index.html, label: Overview }
```

Which form is in use is detected from the first entry. `page` values are
`.html` filenames; the theme matches them against the current page's source
name, so `api.md` matches `api.html`. That is the convention the layouts this
theme replaces used, so converting a site does not mean rewriting its page
list.

### Per-page front matter

Optional, and worth adding as sites are converted. The layouts this theme
replaces hard-coded one `<title>` per site, so every page of a site shipped the
same title to search engines.

```yaml
---
layout: default
title: Appenders
description: Where Semantic Logger writes to, and how to configure each destination.
---
```

## Releases

**`v1` is a moving major tag**, the same convention GitHub Actions uses for
`actions/checkout@v4`. Sites pin `@v1` and pick up fixes on their next build.
Every release also gets an immutable point tag (`v1.0.0`, `v1.1.0`) that never
moves, so a site can pin exactly, and rolling back is changing one line.

The alternative was immutable pins everywhere, which sounds safer and is worse
here: with six sites and one maintainer, a one-line CSS fix would need six
commits across six repos. That is the same per-repo chore that produced the
drift this theme exists to remove, so it would not survive contact with a busy
week.

Two things make the moving tag safe enough:

- **Propagation is lazy.** A theme push does not touch a live site. Pages only
  rebuilds a site when that site is pushed, so a bad theme change reaches sites
  one at a time, as they happen to be touched, not all six at once.
- **Breaking changes go to `v2`.** Anything that would need a site to change
  its `_config.yml` or its markdown is a new major tag, and sites opt in by
  bumping their own pin. Renaming a `project` or `nav` key is breaking.
  Restyling is not.

To cut a release:

```bash
git tag v1.2.0 && git push origin v1.2.0
git tag -f v1   && git push -f origin v1
```

## What the theme provides

- **A grouped sidebar** that takes twelve pages without anyone deciding which
  ones to cut. It collapses to a native `<details>` disclosure below 900px.
- **A full Rouge sheet.** Around twenty-five token classes, designed for both
  themes. Symbols, constants and hash labels are the three highest-frequency
  coloured tokens in Ruby configuration and all three are covered.
- **Both themes**, resolving in all three viewer states: OS preference, and an
  explicit `data-theme` stamp in either direction.
- **The in-page `{:toc}` block** styled as a contents card. Every doc page
  already carries one.
- **Wide tables and code blocks** that scroll inside their own container, so the
  page body never scrolls sideways.
- **A print stylesheet** that drops the navigation and prints link destinations.
- **Mermaid diagrams**, opt-in per page. Set `mermaid: true` in a page's front
  matter and write `~~~mermaid` fences; the module is fetched only by pages that
  ask for it, and it picks its light or dark palette from the resolved page
  theme rather than hard-coding one.

## What it deliberately does not provide

No commercial navigation, no corporate entity block, no pricing, and no hero
art. The only mention of the business is one line in the footer. See
`CLAUDE.md`.

## Licence

Apache 2.0, matching the gems it serves.
