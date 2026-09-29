# frozen_string_literal: true

module Kubik
  module HtmlQualityCheckable
    extend ActiveSupport::Concern

    included do
      after_commit :enqueue_html_quality_check, on: %i[create update], unless: :skip_html_quality_check_enqueue?
    end

    private

    def skip_html_quality_check_enqueue?
      Rails.env.test?
    end

    def enqueue_html_quality_check
      KubikPublishable::HtmlQualityCheckJob.perform_later(self.class.name, id)
    end
  end
end
