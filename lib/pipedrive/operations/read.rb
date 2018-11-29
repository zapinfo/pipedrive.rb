module Pipedrive
  module Operations
    module Read
      extend ActiveSupport::Concern
      include ::Enumerable
      include ::Pipedrive::Utils

      # This method smells of :reek:TooManyStatements but ignores them
      def each(params = {})
        return to_enum(:each, params) unless block_given?
        follow_pagination(:chunk, [], params) { |item| yield item }
      end

      def all(params = {})
        each(params).to_a
      end

      def chunk(params = {})
        res = make_api_call(:get, params)
        return [] unless res.success?
        res
      end

      def find_by_id(id)
        make_api_call(:get, id)
      end
      alias find_id find_by_id

      def find_by_name(*args)
        params = args.extract_options!
        params[:term] ||= args[0]
        raise "term is missing" unless params[:term]
        params[:search_by_email] ||= args[1] ? 1 : 0
        return to_enum(:find_by_name, params) unless block_given?
        follow_pagination(:make_api_call, [:get, "find"], params) { |item| yield item }
      end
      alias find_name find_by_name
    end
  end
end
