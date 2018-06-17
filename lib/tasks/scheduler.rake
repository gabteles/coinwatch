namespace :scheduler do
    task search_currencies: :environment do 
        CurrenciesService.update_exchange_rates
    end
end