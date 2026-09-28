# frozen_string_literal: true

module Kubik
  module Publishable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :kubik_publishable_opts

      private

      def kubik_publishable(column: :published_at, column_type: :datetime)
        @kubik_publishable_opts = { column: column, column_type: column_type }.freeze

        publish_column = column
        type = column_type

        scope :published, lambda {
          case type
          when :boolean
            where(publish_column => true)
          else
            where(publish_column => ..Time.current)
          end
        }
      end
    end

    def published?
      column = self.class.kubik_publishable_opts[:column]
      type = self.class.kubik_publishable_opts[:column_type]

      value = read_attribute(column)
      case type
      when :boolean
        ActiveModel::Type::Boolean.new.cast(value)
      else
        value.present? && value <= Time.current
      end
    end

    def publish!(time = Time.current)
      column = self.class.kubik_publishable_opts[:column]
      type = self.class.kubik_publishable_opts[:column_type]

      value = type == :boolean ? true : time
      update!(column => value)
    end

    def unpublish!
      column = self.class.kubik_publishable_opts[:column]
      type = self.class.kubik_publishable_opts[:column_type]

      value = type == :boolean ? false : nil
      update!(column => value)
    end
  end
end
