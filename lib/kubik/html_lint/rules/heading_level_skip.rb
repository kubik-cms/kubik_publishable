# frozen_string_literal: true

module Kubik
  class HtmlLint
    module Rules
      class HeadingLevelSkip
        def initialize(doc)
          @doc = doc
        end

        def call
          levels = @doc.css("h1, h2, h3, h4, h5, h6").map do |node|
            node.name[1].to_i
          end

          findings = []
          prev = nil
          levels.each do |level|
            if prev && level > prev + 1
              findings << Finding.new(
                code: "heading_level_skip",
                severity: :warning,
                line: nil,
                column: nil,
                message: "Heading level jumps from h#{prev} to h#{level}"
              )
            end
            prev = level
          end
          findings
        end
      end
    end
  end
end
