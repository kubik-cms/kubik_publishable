# frozen_string_literal: true

require "nokogiri"

module Kubik
  class HtmlLint
    Finding = Data.define(:code, :severity, :line, :column, :message)

    @rules = []

    class << self
      attr_reader :rules

      def register(rule_class)
        @rules << rule_class
      end

      def call(html)
        doc = Nokogiri::HTML5.parse(html.to_s, max_errors: -1)
        parse_findings = doc.errors.map do |error|
          Finding.new(
            code: "parse_error",
            severity: :warning,
            line: error.line,
            column: error.column,
            message: error.message
          )
        end

        {
          parse_findings: parse_findings,
          lint_findings: [],
          findings: parse_findings
        }
      end
    end
  end
end

