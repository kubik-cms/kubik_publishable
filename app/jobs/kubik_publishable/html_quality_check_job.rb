# frozen_string_literal: true

module KubikPublishable
  class HtmlQualityCheckJob < ApplicationJob
    def perform(class_name, record_id)
      unless KubikPublishable.config.html_quality_supported?(class_name)
        raise ArgumentError, "unsupported class #{class_name}"
      end

      record = class_name.constantize.find_by(id: record_id)
      return unless record

      report = Kubik::HtmlQuality.run!(record)
      column = KubikPublishable.config.html_quality_report_column
      record.update_column(column, report)
    end
  end
end
