# CLAUDE.md

The shared Jekyll theme for every `reidmorrison.com` documentation site. This
file is the operational manual: what is shared, what must never be shared, the
decisions already settled, and how to change the theme without breaking six
sites at once.

`README.md` is the adoption guide and the config reference. Read it first if the
task is converting a site. Read this one if the task is changing the theme.

## The one rule

**Share the design system. Never share the commercial chrome.**

These are Apache-licensed documentation sites for open-source gems. They are
also, by a long way, the most credible public evidence that the person behind
`reidmorrison.com` can do the work: public commits on code with 77M+ combined
downloads, auditable by anyone before they sign anything.

That evidence only works while the doc sites read as a maintainer's
documentation. A doc site that sells consulting reads to the Ruby community as a
rug-pull risk on the gem itself, and it would cost more credibility than it
could ever generate leads.

So:

- **Shared:** the palette and both themes, the Spectral / IBM Plex Sans / IBM
  Plex Mono pairing, the syntax sheet, the wordmark construction, the shield.
  Someone who reads a gem's docs and later lands on `reidmorrison.com` should
  recognise one hand at work. That recognition is the entire commercial value
  here, and it is enough.
- **Never shared:** navigation to `/services`, `/security`, `/contact` or the
  EOL check; the `Reid Morrison Inc.` entity block or its address; any price;
  any assessment or engagement copy; a contact form; a call to action.
- **The one exception**, and it is the whole allowance: a single footer line,
  *Maintained by Reid Morrison*, linking to `reidmorrison.com`. Someone who
  wants to know who maintains the gem finds out in one click; nobody is sold
  anything.

If a future task asks to add commercial navigation here, that is a reversal of a
considered decision, not an oversight to fix. Say so before doing it.

## Locked decisions

**Delivery is `remote_theme`, tag-pinned.** `jekyll-remote-theme 0.4.3` ships
inside `github-pages 232`, which every consuming site already runs, so this
works on the classic Pages builder with no Actions workflow, no Gemfile change
and no gem release.

**`v1` is a moving major tag**, the GitHub Actions convention. Sites pin `@v1`
and pick up fixes on their next build; every release also gets an immutable
point tag for exact pinning and rollback. Immutable pins everywhere would mean
six commits across six repos for a one-line CSS fix, which is the same chore
that produced the drift this theme removes. Breaking changes, meaning anything
that requires a site to edit its `_config.yml` or its markdown, go to `v2` and
sites opt in. See README.md, "Releases", including the two-command release
recipe.

**No Sass.** GitHub Pages pins `jekyll-sass-converter 1.5.2`, which is libsass
and long dead. Custom properties do everything the theme needs. `rm-docs.css` is
plain CSS with front matter, and that front matter is what makes Jekyll copy it
into `_site` at all.

**The theme ships no config defaults.** Jekyll exposes only `_layouts`,
`_includes`, `_sass` and `assets` from a theme, and `jekyll-remote-theme`
resolves the theme after config load, so a consuming site cannot inherit
anything from this repo's `_config.yml`. Every site declares its own `project`
and `nav` blocks in full. `_config.yml`, `index.md` and the `Gemfile` here are
preview scaffolding and never reach a consuming site.

**Navigation is a grouped sidebar, not a header row.** The layouts this theme
replaces put seven to twelve `.btn` links in the header. That row could not hold
twelve items on a phone, which is the bug `symmetric-encryption` fixed and the
other five doc sites still have; and even on a desktop, a flat row of twelve
gives no sense of where you are in the set. A sidebar takes twelve without
anyone deciding which pages get cut, and grouping makes the shape of the
documentation visible before a page is opened. The second axis, headings within
the current page, is the kramdown `{:toc}` block all 49 doc pages already carry.

**The masthead does not stick.** On a page with forty sections, vertical room is
worth more than a persistent header, and the sidebar is what needs to stay in
view. The old layouts had a sticky header and a JavaScript scroll-padding
measurement to match; both are gone.

**Mermaid is opt-in per page, not global.** The module is ~300KB, and only a
handful of pages across six sites draw diagrams, so it loads when a page sets
`mermaid: true`. Two details in `_includes/mermaid.html` are load-bearing and
easy to lose: kramdown renders a `~~~mermaid` fence as a code block that must be
unwrapped into a `<div class="mermaid">` before init, or the diagram source
renders as literal text; and Mermaid picks its palette once at init and cannot
read CSS custom properties, so the theme is resolved in JavaScript across the
same three states the stylesheet uses. Hard-coding `neutral` leaves a white
diagram glowing on the dark ground.

**No hero art.** `header-rocket-256.png` and `header-banner.jpg` were copied
into every repo and predate the shield. The masthead mark is the identity now.
Removing the hero from a site's `index.md` is part of converting it.

**Code blocks follow the theme.** They are not permanently dark. These pages are
half code, and dark slabs on a light ground read as a zebra. The syntax palette
is designed against both grounds, in its own token set (`--syn-*`) rather than
the UI semantics: `--crit` means "this failed" in the interface and must not
also mean "this is a class name" in a code block.

## The syntax sheet is the part that earns its keep

Until 2026-09-05 `reidmorrison.com/stylesheets/site.css` styled code with six
rules, written to make a handful of illustrative snippets look right. It now
includes this repo's sheet instead, so the argument below is settled and the
sheet has one home. The built doc HTML uses about twenty-five Rouge token
classes. The three highest-frequency coloured
tokens after punctuation are **symbols (`ss`), constants (`no`) and hash labels
(`nl`)** — 871 uses in `semantic_logger` alone — and the six-rule sheet covers
none of them. A straight port would render the most characteristic part of every
Ruby configuration example as undifferentiated body ink.

Section 9 of `rm-docs.css` maps every class Rouge 3.30 emits for Ruby, YAML,
ERB, shell, JSON and diff, grouped by role rather than alphabetically. Anything
unmapped inherits body ink, so a new language looks plain but never invisible.

**Do not simplify this section.** It looks repetitive because Rouge's class
names are two-letter abbreviations; each line is a different token.

**The design system is three includable partials, and reidmorrison.com is the
seventh site (2026-09-05).** `_includes/css/tokens.css`, `css/code.css` and
`css/syntax.css` hold the palette, the code treatment and the Rouge sheet;
`assets/css/rm-docs.css` includes them, and so does
`reidmorrison.com/stylesheets/site.css`, which resolves this repo as a
`remote_theme` for that purpose alone. It takes no layout, no include and no
navigation from here; it keeps its own shell, its own sticky top bar and its own
page styles.

This closes the last direction of drift. The tokens were designed on the
commercial site and copied here on 2026-09-04, which meant a colour had to be
changed twice. Now there is one file. Two things follow:

- **Edits to those three files reach a buyer-facing site.** Everything else in
  this repo reaches documentation only.
- **Anything scoped to a doc-site-only class stays out of them.** Mermaid is the
  worked example: it sits in `rm-docs.css` right after the `css/code.css`
  include rather than inside it, because the commercial site has no diagrams.

## Changing the theme safely

1. **Edit, then look at `index.md` in both themes.** It is a specimen page
   carrying one instance of everything the theme styles, with real Semantic
   Logger and Symmetric Encryption configuration rather than filler. `bundle
   exec jekyll serve`. Note that headless Chrome defaults to dark, so force the
   one you mean with a `data-theme` stamp on `<html>`.
   **Then look at a real site**: `bin/preview ~/src/semantic_logger/docs`. The
   specimen cannot catch everything a forty-section page does.
2. **Check both themes properly.** Tokens resolve in three viewer states: bare
   `:root` is the complete light palette; `@media (prefers-color-scheme: dark)`
   is guarded as `:root:not([data-theme="light"])`; `:root[data-theme="dark"]`
   wins either way. Never declare a colour only inside a media block. Any new
   token needs a value in all three.
3. **Cut a release.** An untagged push reaches nothing: sites resolve `v1`, so
   a change is not live until `v1` is moved onto it.

   ```bash
   git tag v1.2.0 && git push origin v1.2.0
   git tag -f v1   && git push -f origin v1
   ```

4. **Look at one doc site AND at reidmorrison.com before moving `v1`.**
   `bin/preview` renders a doc site against the working copy, so that half
   costs nothing. The commercial site is the seventh consumer of the three
   shared partials and the only one where a regression is in front of a buyer;
   build it against this working copy the same way, with its `overlay.yml`.

A theme change still does not reach a site until that site rebuilds, and Pages
only rebuilds a site when that site is pushed. So propagation is lazy and
staggered, which is what makes the moving tag tolerable.

## Repo map

| Path | Role |
|---|---|
| `assets/css/rm-docs.css` | The whole stylesheet. Eleven numbered sections; three of them are includes. |
| `_includes/css/tokens.css` | The palette, all three viewer states. **Shared with reidmorrison.com.** |
| `_includes/css/code.css` | Code blocks and inline code, scoped to `.content`. **Shared with reidmorrison.com.** |
| `_includes/css/syntax.css` | The Rouge sheet, the section that earns its keep. **Shared with reidmorrison.com.** |
| `_layouts/default.html` | The only layout. Carries three progressive enhancements, all of which degrade safely with JavaScript off. |
| `_includes/head.html` | Per-page titles and descriptions, fonts, Open Graph. |
| `_includes/masthead.html` | The wordmark. The whole of the shared identity. |
| `_includes/sidebar.html` | Grouped or flat navigation, detected from the first entry. |
| `_includes/docs-footer.html` | One line. The only place `reidmorrison.com` is named. |
| `_includes/logo.svg` | Default mark, the plain RM shield. A site overrides it with its own. |
| `_includes/mermaid.html` | Diagram rendering, loaded only on pages with `mermaid: true`. |
| `bin/preview` | Renders a real doc site against this working copy. The only way to see a site before this repo is public. |
| `preview/` | That script's `Gemfile` and config overlay. |
| `index.md` | Preview specimen. Does not reach consuming sites. |
| `_config.yml`, `Gemfile` | Preview scaffolding. Do not reach consuming sites. |

Jekyll exposes only `_layouts`, `_includes`, `_sass` and `assets` from a theme,
so everything else in this table is local tooling and cannot leak into a
consuming site.

## Related

The business folder holds the research this theme came out of, including the
measured drift across the six repos and the comparison of the five delivery
mechanisms. `~/src/reidmorrison.com/CLAUDE.md` carries the commercial rules for
the site this theme shares a palette with; its note about the doc sites keeping
their own look was corrected on 2026-09-04, and on 2026-09-05 that site became a
consumer of the three CSS partials above.
