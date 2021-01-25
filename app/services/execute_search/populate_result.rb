class ExecuteSearch
  module PopulateResult
    include Queries

    def populate_result(search)
      case search.search_type
      when Search::SEARCH_TYPES[:currencies]
        populate_currencies
        populate_currencies_result(search)
      when Search::SEARCH_TYPES[:pairs]
        populate_pairs
        populate_pairs_result(search)
      when Search::SEARCH_TYPES[:rates]
        populate_rates
        populate_rates_result(search)
      else
        raise "#{search.search_type} search not yet implemented"
      end
    end

    # only populates first 300 rates
    def populate_rates
      coinbase_client.rates(query_params[:symbols], rates_start, rates_end, query_params[:interval]).each do |rates_response|
        rates_response[:pair] = find_or_create_pair(rates_response.delete(:symbols))
        Coinbase::Rate.find_or_create_by time: rates_response[:time], interval: rates_response[:interval] do |rt|
          rt.assign_attributes(rates_response)
        end
      end
    end

    def rates_start
      return unless cursor.present?

      direction, unix = Base64.decode64(cursor).split('__')
      return Time.at(unix.to_i).iso8601 if direction == 'after'

      (Time.at(unix.to_i) - interval_hours.hours).iso8601
    end

    def rates_end
      return unless cursor.present?

      direction, unix = Base64.decode64(cursor).split('__')
      return Time.at(unix.to_i).iso8601 if direction == 'before'

      (Time.at(unix.to_i) + interval_hours.hours).iso8601
    end

    def interval_hours
      ((300 * (query_params[:interval] || 60)) / 60) / 60
    end

    def find_or_create_pair(symbols)
      pair = Coinbase::Pair.find_by symbols: symbols
      return pair if pair.present?

      pair_response = coinbase_client.pair(symbols)
      return unless pair_response.present?

      pair_response[:base_currency] = find_or_create_currency(pair_response[:base_currency])
      pair_response[:quote_currency] = find_or_create_currency(pair_response[:quote_currency])

      Coinbase::Pair.create pair_response
    end

    def populate_rates_result(search)
      search.result = RateBlueprint.render_as_hash rates.limit(limit).paginated(cursor)
      search.expires_at = expires_at
      search.save
    end

    def populate_pairs
      existing_pair_names = Coinbase::Pair.all.map(&:symbols)

      pairs_to_persist = coinbase_client.pairs.reject do |c|
        existing_pair_names.include?(c[:symbols])
      end

      pairs_to_persist.each do |p|
        p[:base_currency] = find_or_create_currency(p[:base_currency])
        p[:quote_currency] = find_or_create_currency(p[:quote_currency])
        Coinbase::Pair.create p
      end
    end

    def find_or_create_currency(symbol)
      currency = Coinbase::Currency.find_by symbol: symbol
      return currency if currency.present?

      currency_response = coinbase_client.currency(symbol)
      return unless currency_response.present?

      Coinbase::Currency.create currency_response
    end

    def populate_pairs_result(search)
      search.result = PairBlueprint.render_as_hash pairs.limit(limit).paginated(cursor)
      search.expires_at = expires_at
      search.save
    end

    def populate_currencies
      existing_currency_names = Coinbase::Currency.all.map(&:name)

      currencies_to_persist = coinbase_client.currencies.reject do |c|
        existing_currency_names.include?(c[:name])
      end

      currencies_to_persist.each do |c|
        Coinbase::Currency.create(c)
      end
    end

    def populate_currencies_result(search)
      search.result = CurrencyBlueprint.render_as_hash currencies_by_name.limit(limit).paginated(cursor)
      search.expires_at = expires_at
      search.save
    end
  end
end
