# frozen_string_literal: true

module KubikPublishable
  class Configuration
    attr_accessor :html_quality_classes,
                  :html_quality_report_column,
                  :html_quality_renderer

    def initialize
      @html_quality_classes = []
      @html_quality_report_column = :last_html_quality_report
    end

    def html_quality_supported?(class_name)
      html_quality_classes.map(&:to_s).include?(class_name.to_s)
    end
  end
end
