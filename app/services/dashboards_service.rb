module DashboardsService
    ORDERS_BY_CURRENCY_FOR_USER = lambda do |user|
        Order.where(user_uuid: user.id).group(:currency)
    end

    CALCULATE_CURRENCY_PORTFOLIO = lambda do |owned_totals, investment_totals, (currency, exchange_rate)| 
        owned = owned_totals[currency]
        investment = investment_totals[currency]
        current_value = (exchange_rate * owned).floor(2)

        { 
            currency: currency,
            owned: owned,
            investment: investment,
            current_value: current_value,
            profit: current_value - investment,
            current_exchange_rate: exchange_rate
        }
    end.curry

    CALCULATE_PORTFOLIO_TOTALS = lambda do |portfolio, currency_detail|
        totals = portfolio[:totals]

        {
            totals: {
                investment: totals[:investment] + currency_detail[:investment],
                current_value: totals[:current_value] + currency_detail[:current_value],
                profit: totals[:profit] + currency_detail[:profit]
            },
            currency_details: portfolio[:currency_details] + [currency_detail]
        }
    end

    BLANK_PORTFOLIO = { 
        totals: {
            investment: 0.0,
            current_value: 0.0,
            profit: 0.0
        }, 
        currency_details: [] 
    }
    
    module_function

    def portfolio_for(user)
        Rails.cache.fetch("portfolio/#{user.id}", expires_in: 15.minutes) do
            orders = ORDERS_BY_CURRENCY_FOR_USER[user]
            owned_totals = orders.sum(:amount)
            investment_totals = orders.sum(:investment)
            
            CurrenciesService.find_exchange_rates(*orders.pluck(:currency))
                             .map(&CALCULATE_CURRENCY_PORTFOLIO[owned_totals, investment_totals])
                             .reduce(BLANK_PORTFOLIO, &CALCULATE_PORTFOLIO_TOTALS)
        end
    end
end