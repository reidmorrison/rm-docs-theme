---
layout: default
title: Theme specimen
description: Every element the theme styles, on one page, for checking a change before it ships to six sites.
---

This page exists to be looked at. It carries one instance of everything the
theme styles, so a change to `assets/css/rm-docs.css` can be checked in both
themes before it reaches six documentation sites. The code samples are real
Semantic Logger and Symmetric Encryption configuration, not filler, because the
syntax sheet is the part of this theme most likely to be wrong and Ruby
configuration is what it has to render.

**Contents**

* toc
{:toc}

## Ruby

The tokens that matter most here are symbols, constants and hash labels. In the
six doc sites they are the three highest-frequency coloured tokens after
punctuation, and the stylesheet this theme replaces left all three uncoloured.

```ruby
require "semantic_logger"

SemanticLogger.default_level = :info
SemanticLogger.application    = "my_app"

SemanticLogger.add_appender(
  file_name: "log/production.log",
  formatter: :json,
  level:     :warn
)

class PaymentProcessor
  include SemanticLogger::Loggable

  MAX_ATTEMPTS = 3
  RETRYABLE    = [Net::ReadTimeout, Errno::ECONNRESET].freeze

  def call(order)
    logger.measure_info("Charged order", metric: "payments/charge") do
      attempts = 0
      begin
        attempts += 1
        gateway.charge!(order.total_cents, currency: "USD")
      rescue *RETRYABLE => exc
        logger.warn("Retrying", attempt: attempts, error: exc.message)
        retry if attempts < MAX_ATTEMPTS
        raise
      end
    end
  end

  private

  def gateway
    @gateway ||= Gateway.new(token: ENV.fetch("GATEWAY_TOKEN"))
  end
end
```

Interpolation, escapes, regular expressions and global variables all get their
own colour, because a string that contains a substitution is not the same thing
as a string that does not:

```ruby
name  = "production"
path  = "log/#{name}.log"
quiet = /\A(healthcheck|assets)\z/
$stdout.sync = true
puts "Writing to \t#{path}\n" unless request.path =~ quiet
```

## YAML

```yaml
# config/symmetric-encryption.yml
production:
  ciphers:
    - key_filename:  /etc/keys/production_v3.key
      iv_filename:   /etc/keys/production_v3.iv
      cipher_name:   aes-256-cbc
      version:       3
      always_add_header: true
    - key_filename:  /etc/keys/production_v2.key
      version:       2
```

## Shell

```bash
# Rotate to a new key version without downtime
bundle exec symmetric-encryption --rotate-keys config/symmetric-encryption.yml \
  --environment production \
  --rolling-deploy
```

## Diff

```diff
   SemanticLogger.add_appender(
-    file_name: "log/production.log",
-    formatter: :default
+    file_name: "log/production.log",
+    formatter: :json,
+    level:     :warn
   )
```

## Prose, links and inline code

Body copy sits on a measure of about 76 characters, which is wider than the
65-character ideal for a novel and about right for technical prose that is
constantly interrupted by identifiers like `SemanticLogger::Appender::File` and
by [links to another page](index.html). Inline code is sized in `em`, so it
tracks whatever it sits inside, including headings and table cells.

> A block quote, for the occasional warning or aside that is not a full
> callout. It carries a rule rather than a fill, so it does not compete with
> the code blocks on a page that is mostly code.

### A third-level heading

Third-level headings are the deepest level in the table of contents, matching
`toc_levels: "2..3"`. Below this, headings are still styled but stop appearing
in the contents card.

1. An ordered list item.
2. A second, with a nested list:
   - a nested bullet,
   - and another.
3. A third.

#### A fourth-level heading

Set in the body face at body size, distinguished by weight rather than by size,
so a deeply nested API reference does not run out of scale.

##### A fifth-level heading

Set in mono caps, which is the same device the sidebar group titles and the
table headers use.

## Tables

Wide tables scroll inside their own container, so the page body never scrolls
sideways no matter how many columns an appender option table grows.

| Option | Type | Default | Description |
|---|---|---|---|
| `:level` | Symbol | `:info` | Lowest level this appender will log |
| `:formatter` | Symbol | `:default` | `:default`, `:color`, `:json` or a Proc |
| `:filter` | Regexp, Proc | `nil` | Applied to the class name before logging |
| `:application` | String | `SemanticLogger.application` | Name recorded on every log event |
| `:metrics` | Boolean | `false` | Whether the appender receives metric-only events |

## Horizontal rule

---

That rule, and this paragraph, are the last things on the specimen.
