class ExecuteSearch
  module CursorPagination
    include Queries

    def calculate_cursor(search)
      case search.search_type
      when Search::SEARCH_TYPES[:currencies]
        currencies_cursor(search)
      when Search::SEARCH_TYPES[:pairs]
        pairs_cursor(search)
      when Search::SEARCH_TYPES[:rates]
        rates_cursor(search)
      end
    end

    def currencies_cursor(search)
      previous_name = first_search_result_name(search) == first_currency_name ? nil : first_search_result_name(search)
      next_name = last_search_result_name(search) == last_currency_name ? nil : last_search_result_name(search)
      cursor_hash(previous_name, next_name)
    end

    def pairs_cursor(search)
      previous_symbols = first_search_result_symbols(search) == first_pair_symbols ? nil : first_search_result_symbols(search)
      next_symbols = last_search_result_symbols(search) == last_pair_symbols ? nil : last_search_result_symbols(search)
      cursor_hash(previous_symbols, next_symbols)
    end

    def rates_cursor(search)
      previous_time = first_search_result_time(search) == first_rate_time ? rates_previous_time : first_search_result_time(search)
      next_time = last_search_result_time(search) == last_rate_time ? rates_next_time : last_search_result_time(search)
      cursor_hash(previous_time, next_time)
    end

    def rates_next_time
      sort&.include?('DESC') ? last_rate_time : nil
    end

    def rates_previous_time
      sort&.include?('DESC') ? nil : first_rate_time
    end

    def first_search_result_time(search)
      @first_search_result_time ||= search.result.any? && Time.parse(search.result.first['time']).to_i
    end

    def last_search_result_time(search)
      @last_search_result_time ||= search.result.any? && Time.parse(search.result.last['time']).to_i
    end

    def first_search_result_symbols(search)
      @first_search_result_symbols ||= search.result.any? && search.result.first['symbols']
    end

    def last_search_result_symbols(search)
      @last_search_result_symbols ||= search.result.any? && search.result.last['symbols']
    end

    def first_search_result_name(search)
      @first_search_result_name ||= search.result.any? && search.result.first['name']
    end

    def last_search_result_name(search)
      @last_search_result_name ||= search.result.any? && search.result.last['name']
    end

    def cursor_hash(previous, subsequent)
      {
        previous_page: previous && Base64.strict_encode64("#{sort&.include?('DESC') ? 'after' : 'before'}__#{previous}"),
        next_page: subsequent && Base64.strict_encode64("#{sort&.include?('DESC') ? 'before' : 'after'}__#{subsequent}")
      }
    end
  end
end
