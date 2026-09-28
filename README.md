# kubik_publishable

Shared publish/unpublish semantics, Active Admin actions, and HTML lint helpers for Kubik CMS models.

## Installation

```ruby
gem "kubik_publishable", github: "kubik-cms/kubik_publishable"
```

For local development, use `path: "vendor/kubik_publishable"` or a devcontainer mount at `/kubik_publishable`.

## Usage

```ruby
class Page < ApplicationRecord
  include Kubik::Publishable

  kubik_publishable column: :published_at
end
```

Register admin publish actions via `Kubik::PublishableAdminAction`. HTML lint rules live under `Kubik::HtmlLint`.
