module CurrenciesService
    module_function
    
    def get_all
        return [
            { symbol: 'BTC', value_in_usd: 15000.00 },
            { symbol: 'ETH', value_in_usd: 690.74 },
        # TODO: Temporary (Remove when it's on database)
        ].map { |c| OpenStruct.new(c) }
    end
end