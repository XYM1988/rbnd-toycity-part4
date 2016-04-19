require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  # Your code goes here!
    product_names = []
    prices = []
    fake_brands = ['Sony', 'Microsoft', 'Niki', 'Nintendo', 'Google']
    10.times do
      Product.create(brand: fake_brands.sample,
                     name: Faker::Commerce.product_name,
                     price: Faker::Commerce.price)
    end
  end
