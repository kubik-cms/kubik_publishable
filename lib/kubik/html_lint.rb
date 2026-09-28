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

        lint_findings = rules.flat_map { |rule_class| rule_class.new(doc).call }

        {
          parse_findings: parse_findings,
          lint_findings: lint_findings,
          findings: parse_findings + lint_findings
        }
      end
    end
  end
end

require "kubik/html_lint/rules/missing_h1"
require "kubik/html_lint/rules/multiple_h1"
require "kubik/html_lint/rules/heading_level_skip"
require "kubik/html_lint/rules/img_missing_alt"

Kubik::HtmlLint.register(Kubik::HtmlLint::Rules::MissingH1)
Kubik::HtmlLint.register(Kubik::HtmlLint::Rules::MultipleH1)
Kubik::HtmlLint.register(Kubik::HtmlLint::Rules::HeadingLevelSkip)
Kubik::HtmlLint.register(Kubik::HtmlLint::Rules::ImgMissingAlt)
