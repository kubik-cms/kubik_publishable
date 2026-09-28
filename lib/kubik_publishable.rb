# frozen_string_literal: true

module KubikPublishable
  class Error < StandardError; end
end

module Kubik
  require "kubik/publishable"
  require "kubik/publishable_admin_action"
  require "kubik/html_lint"
end
