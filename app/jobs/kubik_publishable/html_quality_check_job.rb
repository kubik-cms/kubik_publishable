# frozen_string_literal: true

module KubikPublishable
  class HtmlQualityCheckJob < ApplicationJob
    def perform(class_name, record_id)
      record = class_name.constantize.find_by(id: record_id)
      return unless record
      return unless html_quality_enabled?(record)

      unless KubikPublishable.config.html_quality_supported?(class_name)
        raise ArgumentError, "unsupported class #{class_name}"
      end

      report = Kubik::HtmlQuality.run!(record)
      column = KubikPublishable.config.html_quality_report_column
      record.update_column(column, report)
    end

    def html_quality_enabled?(record)
      return true unless record.respond_to?(:html_quality_checks_enabled_for_model?, true)

      record.send(:html_quality_checks_enabled_for_model?)
    end
  end
end
