class ExecuteSearch
  module Queries
    module Pair
      def pairs
        return @pairs if @pairs

        @pairs = Coinbase::Pair.includes(:base_currency, :quote_currency).order(pairs_sort || :symbols)
        @pairs = @pairs.search_by_symbols(query_params[:symbols]) if query_params[:symbols].present?
        @pairs = @pairs.search_by_base_currency(query_params[:base_currency]) if query_params[:base_currency].present?
        if query_params[:quote_currency].present?
          @pairs = @pairs.search_by_quote_currency(query_params[:quote_currency])
        end
        @pairs
      end

      def pairs_sort
        return sort unless sort&.include?('currency')

        column, direction = sort.split(' ')
        column_name = column == 'base_currency' ? 'coinbase_currencies.name' : "#{column.pluralize}_coinbase_pairs.name"
        [[column_name, direction].join(' '), ['symbols', direction].join(' ')]
      end

      def first_pair_symbols
        pairs.first&.symbols
      end

      def last_pair_symbols
        pairs.last&.symbols
      end
    end
  end
end
