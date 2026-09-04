# rm-docs-theme

The shared Jekyll theme for the [reidmorrison.com](https://reidmorrison.com)
documentation sites. One palette, one type pairing, one syntax sheet, one
sidebar, across every gem's `docs/` folder.

Preview it by running this repo on its own:

```bash
bundle install
bundle exec jekyll serve
```

`index.md` is a specimen page carrying one instance of everything the theme
styles. Look at it in both light and dark before shipping a change.

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

Pin a tag, not a branch. A push to this repo then cannot change six sites at
once; you bump each site's pin when you are ready to look at it.

**3. Add the project mark, if it has one.**

Drop an inline SVG at `docs/_includes/logo.svg`. It overrides the theme's
default shield, because Jekyll searches a site's `_includes` before the theme's.
Two requirements:

- It must be **inline SVG, not an `<img>`**. Its fills read the `--logo-ink` and
  `--logo-accent` custom properties so one file serves both themes, and an
  externally referenced SVG cannot see the page's CSS.
- It must carry `class="brand-mark"` and `aria-hidden="true"`.

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

## What it deliberately does not provide

No commercial navigation, no corporate entity block, no pricing, and no hero
art. The only mention of the business is one line in the footer. See
`CLAUDE.md`.

## Licence

Apache 2.0, matching the gems it serves.
