# frozen_string_literal: true

module Pipedrive
  class SearchResult < Base
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete

    def entity_name
      'searchResults'
    end

    def field(params = {})
      make_api_call(:get, 'field', params)
    end
  end
end
