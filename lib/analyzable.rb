module Analyzable
  # Your code goes here!

  def count_by_brand(data)
    # count_by_brand: Count the number of product from each brands
    # parameters: data -> the dictionary of the data we want to count
    result = {}
    data.each do |product|
      brand = product.brand
      # doesn't have this brand, set it to 1
      if result[brand].nil?
        result[brand] = 1
      else
        result[brand] += 1
      end
    end
    return result
  end

  def count_by_name(data)
    # count_by_name: Count the number of product from each brands
    # parameters: data -> the dictionary of the data we want to count
    result = {}
    data.each do |product|
      name = product.name
      if result[name].nil?
        result[name] = 1
      else
        result[name] += 1
      end
    end

    return result
  end

  def average_price(data)
    # average_price: Calculate the average of the data we passed in
    # parameters: data -> the dictionary of the data we want to count
    cnt = 0
    amount = 0
    data.each do |product|
      amount += product.price.to_f
      cnt += 1
    end

    return (amount / cnt).round(2)
  end

  def print_report(data)
    # print_report: Generate the report for the data we passed in.
    # parameters: data -> the dictionary of the data we want to count
    result = "The Average Price is : #{average_price(data)}\n"
    result += "Inventory by Brand: \n"
    result += "\n"
    count_by_brand(data).each do |key, value|
      result += "* #{key}: #{value}\n"
    end
    result += "\n"
    result += "Inventory by Name: \n"
    count_by_name(data).each do |key, value|
      result += "* #{key}: #{value}\n"
    end
    puts result
    return result
  end
end