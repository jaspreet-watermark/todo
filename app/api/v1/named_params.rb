# frozen_string_literal: true

module API
  module V1
    module NamedParams
      extend ::Grape::API::Helpers

      params :item do
        optional :description, type: String, desc: 'Item Description'
        optional :status, type: String, values: Item.statuses, desc: 'Item Status'
        optional :due_at, type: String, desc: 'Item Due At DateTime'
        optional :started_at, type: String, desc: 'Item started At DateTime'
        optional :completed_at, type: String, desc: 'Item Completed At DateTime'
        group :tags, type: Array[JSON], desc: 'Item Tags' do
          optional :name, type: String, desc: 'Tag Name'
        end
      end
    end
  end
end
