module Pipedrive
  class Person < Base
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Utils

    def deals(*args)
      params = args.extract_options!
      params.symbolize_keys!
      id = params.delete(:id) || args[0]
      fail "id must be provided" unless id
      return to_enum(:deals, id, params) unless block_given?
      follow_pagination(:make_api_call, [:get, id, :deals], params) { |item| yield item }
    end
  end
end
