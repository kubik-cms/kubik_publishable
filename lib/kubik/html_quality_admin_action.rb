# frozen_string_literal: true

module Kubik
  module HtmlQualityAdminAction
    extend ActiveSupport::Concern

    def self.included(base)
      route_key = base.config.resource_name.singular_route_key
      run_check_path_helper = "run_html_check_admin_#{route_key}_path"
      panel_path_helper = "html_quality_panel_admin_#{route_key}_path"
      report_column = KubikPublishable.config.html_quality_report_column

      base.controller do
        helper_method :html_quality_check_allowed?

        def html_quality_check_allowed?(record)
          if defined?(Kubik::Features) && Kubik::Features.respond_to?(:html_quality_enabled_for_model?)
            return Kubik::Features.html_quality_enabled_for_model?(record)
          end

          KubikPublishable.config.html_quality_supported?(record.class.name)
        end
      end

      base.send(:member_action, :html_quality_panel, method: :get) do
        unless html_quality_check_allowed?(resource)
          head :not_found
          next
        end

        respond_to do |format|
          format.html do
            if turbo_frame_request?
              render "kubik_publishable/admin/html_quality_panel",
                     locals: { resource: resource, run_check_path: send(run_check_path_helper, resource) },
                     layout: false
            else
              redirect_to resource_path(resource, only_path: true)
            end
          end
        end
      end

      base.send(:member_action, :run_html_check, method: :post) do
        unless html_quality_check_allowed?(resource)
          redirect_to resource_path(resource), alert: "HTML quality checks are disabled for this content type."
          next
        end

        report = Kubik::HtmlQuality.run!(resource)
        resource.update_column(report_column, report)

        respond_to do |format|
          format.html do
            if turbo_frame_request?
              render "kubik_publishable/admin/html_quality_panel",
                     locals: { resource: resource.reload, run_check_path: send(run_check_path_helper, resource) },
                     layout: false
            else
              redirect_to resource_path(resource),
                          notice: "HTML quality check finished (#{report[:summary][:warnings]} warnings)."
            end
          end
        end
      end
    end
  end
end
