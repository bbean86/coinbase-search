class ExecuteSearch
  module Queries
    module Currency
      def currencies_by_name
        return @currencies_by_name if @currencies_by_name

        query = Coinbase::Currency.order(sort || :name)
        query = query.search_by_name(query_params[:name]) if query_params[:name].present?
        query = query.search_by_symbol(query_params[:symbol]) if query_params[:symbol].present?

        @currencies_by_name = query
      end

      def first_currency_name
        currencies_by_name.first&.name
      end

      def last_currency_name
        currencies_by_name.last&.name
      end
    end
  end
end
