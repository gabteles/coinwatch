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

    UPDATE_CURRENCY_EXCHANGE_RATE_PARAMS = lambda do |(symbol, exchange_rate)|
        [symbol, { value_in_usd: exchange_rate }]
    end

    module_function
    
    def get_all
        Currency.all
    end

    def update_exchange_rates
        updates = Currency.in_batches(of: 75) 
                          .lazy
                          .map(&MOUNT_URL_FROM_CURRENCY_LIST)
                          .flat_map(&FETCH_EXCHANGE_RATES)
                          .map(&UPDATE_CURRENCY_EXCHANGE_RATE_PARAMS)
                          .to_h
        
        Currency.update(updates.keys, updates.values)
    end

    def find_exchange_rates(*currencies)
        Currency.find(currencies)
                .pluck(:symbol, :value_in_usd)
                .to_h
    end
end