# frozen_string_literal: true

module Kubik
  module HtmlQuality
    module_function

    def run!(record)
      renderer = KubikPublishable.config.html_quality_renderer
      raise ArgumentError, "html_quality_renderer is not configured" unless renderer

      html = renderer.call(record)
      result = Kubik::HtmlLint.call(html)
      findings = serialize_findings(result[:findings])

      {
        checked_at: Time.current.iso8601,
        findings: findings,
        summary: { warnings: findings.size }
      }
    rescue StandardError => e
      {
        checked_at: Time.current.iso8601,
        findings: [
          {
            code: "render_failed",
            severity: "warning",
            line: nil,
            column: nil,
            message: e.message
          }
        ],
        summary: { warnings: 1 }
      }
    end

    def serialize_findings(findings)
      findings.map do |finding|
        {
          code: finding.code,
          severity: finding.severity.to_s,
          line: finding.line,
          column: finding.column,
          message: finding.message
        }
      end
    end
  end
end
