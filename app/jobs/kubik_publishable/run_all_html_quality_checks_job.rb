# frozen_string_literal: true

module KubikPublishable
  class RunAllHtmlQualityChecksJob < ApplicationJob
    def perform
      KubikPublishable.config.html_quality_classes.each do |class_name|
        klass = class_name.to_s.constantize
        klass.find_each do |record|
          HtmlQualityCheckJob.perform_later(klass.name, record.id)
        end
      end
    end
  end
end
