module OrdersService
    module_function
    
    def fetch_for_user(user, page_number)
        return Order
            .where(user_uuid: user.id)
            .order(created_at: :desc)
            .page(page_number)
            .per(10)
    end

    def create(user, params)
        order = Order.new(params)
        order.id = SecureRandom.uuid
        order.user_uuid = user.id
        order.save
    end
end