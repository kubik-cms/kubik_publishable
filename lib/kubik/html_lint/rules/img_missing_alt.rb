# frozen_string_literal: true

module Kubik
  class HtmlLint
    module Rules
      class ImgMissingAlt
        def initialize(doc)
          @doc = doc
        end

        def call
          @doc.css("img").filter_map do |img|
            next if img.has_attribute?("alt")

            Finding.new(
              code: "img_missing_alt",
              severity: :warning,
              line: img.line,
              column: nil,
              message: "Image is missing an alt attribute"
            )
          end
        end
      end
    end
  end
end
