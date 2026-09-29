# frozen_string_literal: true

module Kubik
  module HtmlQualityAdminAction
    extend ActiveSupport::Concern

    def self.included(base)
      route_key = base.config.resource_name.singular_route_key
      path_helper = "run_html_check_admin_#{route_key}_path"
      report_column = KubikPublishable.config.html_quality_report_column

      base.send(:member_action, :run_html_check, method: :post) do
        report = Kubik::HtmlQuality.run!(resource)
        resource.update_column(report_column, report)
        redirect_to resource_path(resource),
                    notice: "HTML quality check finished (#{report[:summary][:warnings]} warnings)."
      end

      base.send(:action_item, :run_html_check, only: %i[show]) do
        link_to "Run HTML check", send(path_helper, resource), method: :post
      end
    end
  end
end
