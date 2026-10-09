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
      KubikPublishable::HtmlQualityCheckJob.perform_now(self.class.name, id)
    end

    def html_quality_checks_enabled_for_model?
      if defined?(Kubik::Features) && Kubik::Features.respond_to?(:html_quality_enabled_for_model?)
        return Kubik::Features.html_quality_enabled_for_model?(self)
      end

      KubikPublishable.config.html_quality_supported?(self.class.name)
    end
  end
end
