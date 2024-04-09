class Order < ApplicationRecord
    validates :product_name, presence: true
    validates :status, presence: true
end
