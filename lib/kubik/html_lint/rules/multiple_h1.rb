# frozen_string_literal: true

module Kubik
  class HtmlLint
    module Rules
      class MultipleH1
        def initialize(doc)
          @doc = doc
        end

        def call
          headings = @doc.css("h1")
          return [] if headings.size <= 1

          [
            Finding.new(
              code: "multiple_h1",
              severity: :warning,
              line: nil,
              column: nil,
              message: "Document has #{headings.size} h1 headings (expected one)"
            )
          ]
        end
      end
    end
  end
end
