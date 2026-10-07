# frozen_string_literal: true

module Kubik
  module HtmlQualityCheckable
    extend ActiveSupport::Concern

    included do
      after_commit :enqueue_html_quality_check, on: %i[create update], unless: :skip_html_quality_check_enqueue?
    end

    private

    def skip_html_quality_check_enqueue?
      return true if Rails.env.test?
      return true unless html_quality_checks_enabled_for_model?

      false
    end

    def enqueue_html_quality_check
      KubikPublishable::HtmlQualityCheckJob.perform_later(self.class.name, id)
    end

    def html_quality_checks_enabled_for_model?
      if defined?(KubikSettings::ResourceResolver)
        resource_key = KubikSettings::ResourceResolver.resource_key_for(self)
        if resource_key && KubikSettings::ResourceResolver.registered?(resource_key)
          definition = KubikSettings.configuration.resource_registry[resource_key.to_s]
          if definition.setting_meta(:html_quality_enabled)
            stored = KubikSettings::ResourceResolver.get_stored_or_fallback_only(resource_key, :html_quality_enabled)
            return stored unless stored.nil?
          end
        end
      end

      KubikPublishable.config.html_quality_supported?(self.class.name)
    end
  end
end
