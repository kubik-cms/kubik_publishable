# frozen_string_literal: true

module Kubik
  module PublishableAdminAction
    extend ActiveSupport::Concern

    def self.included(base)
      route_key = base.config.resource_name.singular_route_key
      base_class = base.config.resource_class_name.classify.constantize

      unless base_class.respond_to?(:kubik_publishable_opts) && base_class.kubik_publishable_opts
        raise ArgumentError, "#{base_class} must call kubik_publishable before including PublishableAdminAction"
      end

      base.send(:member_action, :publish, method: :post) do
        resource.publish!
        redirect_to resource_path(resource), notice: "Published."
      end

      base.send(:member_action, :unpublish, method: :post) do
        resource.unpublish!
        redirect_to resource_path(resource), notice: "Unpublished."
      end

      publish_path_helper = "publish_admin_#{route_key}_path"
      unpublish_path_helper = "unpublish_admin_#{route_key}_path"
      human_name = base_class.model_name.human.downcase

      base.send(:action_item, :publish, only: %i[edit show], if: proc { !resource.published? }) do
        link_to "Publish now",
                send(publish_path_helper, resource),
                method: :post,
                data: { confirm: "Publish this #{human_name} now?" }
      end

      base.send(:action_item, :unpublish, only: %i[edit show], if: proc { resource.published? }) do
        link_to "Unpublish",
                send(unpublish_path_helper, resource),
                method: :post,
                data: { confirm: "Unpublish this #{human_name}?" }
      end
    end
  end
end
