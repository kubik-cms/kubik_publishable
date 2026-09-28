# frozen_string_literal: true

module Kubik
  class HtmlLint
    module Rules
      class MissingH1
        def initialize(doc)
          @doc = doc
        end

        def call
          return [] if @doc.css("h1").any?

          [
            Finding.new(
              code: "missing_h1",
              severity: :warning,
              line: nil,
              column: nil,
              message: "Document has no h1 heading"
            )
          ]
        end
      end
    end
  end
end
