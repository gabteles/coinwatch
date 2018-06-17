module CurrenciesService
    MOUNT_URL_FROM_CURRENCY_LIST = lambda do |currencies|
        symbols = currencies.pluck(:symbol).join(',')
        "https://min-api.cryptocompare.com/data/pricemulti?fsyms=#{symbols}&tsyms=USD"
    end

    FETCH_EXCHANGE_RATES = lambda do |url|
        response = HTTParty.get(url)
        next [] unless response.success?
        response.parsed_response.map { |r| [r[0], r[1]["USD"]] }
    end

    UPDATE_CURRENCY_EXCHANGE_RATE = lambda do |(symbol, exchange_rate)|
        Currency.update(symbol, value_in_usd: exchange_rate)
    end

    module_function
    
    def get_all
        Currency.all
    end

    def update_exchange_rates
        Currency.in_batches(of: 100) 
                .lazy
                .map(&MOUNT_URL_FROM_CURRENCY_LIST)
                .flat_map(&FETCH_EXCHANGE_RATES)
                .each(&UPDATE_CURRENCY_EXCHANGE_RATE)
    end
end