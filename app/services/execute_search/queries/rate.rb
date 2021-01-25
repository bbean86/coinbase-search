class ExecuteSearch
  module Queries
    module Rate
      def rates
        @rates ||= Coinbase::Rate
                   .order(sort || :time)
                   .includes(:pair)
                   .by_symbols(query_params[:symbols])
                   .by_interval(query_params[:interval] || 60)
      end

      def first_rate_time
        rates.first&.time&.to_i
      end

      def last_rate_time
        rates.last&.time&.to_i
      end
    end
  end
end
