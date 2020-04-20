# frozen_string_literal: true

module Pipedrive
  class User < Base
    include ::Pipedrive::Operations::Read
  end
end
