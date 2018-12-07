module Pipedrive
  class User < Base
    include ::Pipedrive::Operations::Read
  end
end
