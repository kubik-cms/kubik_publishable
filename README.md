# kubik_publishable

Shared publish/unpublish semantics, Active Admin actions, HTML lint helpers, and optional HTML quality checks for Kubik CMS models.

## Installation

```ruby
gem "kubik_publishable", github: "kubik-cms/kubik_publishable"
```

For local development, use `path: "vendor/kubik_publishable"`.

## Usage

```ruby
class Page < ApplicationRecord
  include Kubik::Publishable
  include Kubik::HtmlQualityCheckable

  kubik_publishable column: :published_at
end
```

Register admin publish actions via `Kubik::PublishableAdminAction`. `Kubik::HtmlLint` reports HTML5 parse validity only (malformed markup). On-page SEO checks live in `kubik_metatagable` (`Kubik::Reporting::SeoReport`).

### HTML quality (optional)

Configure a renderer that returns public HTML for a record, then include `Kubik::HtmlQualityCheckable` and `Kubik::HtmlQualityAdminAction`:

```ruby
# config/initializers/kubik_publishable.rb
KubikPublishable.configure do |config|
  config.html_quality_classes = %w[Page NewsArticle]
  config.html_quality_renderer = ->(record) { MyApp::PublicHtmlRenderer.render(record) }
end
```

Admin panel partial: `kubik_publishable/admin/html_quality_panel`.

Jobs: `KubikPublishable::HtmlQualityCheckJob`, `KubikPublishable::RunAllHtmlQualityChecksJob`.
