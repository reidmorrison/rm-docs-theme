# A gemspec is not needed to CONSUME this theme: `remote_theme` fetches the
# repo directly and never resolves a gem. It exists for two other reasons.
#
# 1. It lets a consuming site point at a local checkout while converting:
#
#      # docs/Gemfile
#      gem "rm-docs-theme", path: "../../rm-docs-theme"
#
#    with `theme: rm-docs-theme` in a config overlay. That exercises the real
#    Jekyll theme layering, including a site's _includes overriding the
#    theme's, so a conversion can be checked before this repo is public.
#
# 2. It keeps the gem-theme route open if these sites ever move to a GitHub
#    Actions build. Nothing depends on that today.

Gem::Specification.new do |spec|
  spec.name     = "rm-docs-theme"
  spec.version  = "1.0.0"
  spec.authors  = ["Reid Morrison"]
  spec.summary  = "Shared Jekyll theme for the reidmorrison.com documentation sites"
  spec.homepage = "https://github.com/reidmorrison/rm-docs-theme"
  spec.license  = "Apache-2.0"

  # Mirrors what Jekyll exposes from a theme: layouts, includes, sass and
  # assets. Everything else in this repo is preview scaffolding.
  spec.files = Dir.glob("{_layouts,_includes,_sass,assets}/**/*") +
               %w[LICENSE README.md]

  spec.add_runtime_dependency "jekyll", ">= 3.9", "< 5.0"
end
