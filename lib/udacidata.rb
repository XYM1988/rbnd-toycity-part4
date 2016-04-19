require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@TOYDATABASE = File.dirname(__FILE__) + '/../data/data.csv'

  create_finder_methods(:id, :brand, :name, :price)

  # using this function to save details into database .csv file.
  def save_to_db
    CSV.open(@@TOYDATABASE, 'ab') do |csv|
      csv << [@id, @brand, @name, @price]
    end
  end

  def [](iv)
    instance_variable_get("@#{iv}")
  end

  def self.create(attributes = nil)
    record = new(attributes)
    record.save_to_db
    return record
  end

  def self.all
    data = CSV.read(@@TOYDATABASE)
    data.shift
    
    # Extract all records and write them into "all_records" so that it could be easy to be returned.
    all_records = []
    data.each do |record|
      all_records << new(id: record[0], brand: record[1], name: record[2], price: record[3])
    end

    return all_records
  end

  def self.first(n = 1)
    # first: Return a Product object that represents the first product in the database.
    # parameters: n -> the number of selected objects
    
    # Citation: https://www.codecademy.com/forum_questions/52a112378c1cccb0f6001638
    if n > 1
      # Citation: http://stackoverflow.com/questions/3525351/how-to-select-array-elements-in-a-given-range-in-ruby
      return all[0...n]
    else
      return all[0]
    end
  end

  def self.last(n = nil)
    # last: Return a Product object that represents the last product in the database
    # parameters: n -> the number of selected objects
    
    # Citation: https://www.codecademy.com/forum_questions/52a112378c1cccb0f6001638
    if n.nil?
      return all[-1]
    else
      return all.last(n)
    end
  end

  def self.find(id)
    # find: Return a Product object for the product with a given product id.
    # parameter: id -> the taget id to find
    all.each do |record|
      return record if record.id == id
    end
    
    # If the ID we want is not able to be found, ruby will execute this final line
    # This exception represents that we can't find the result with that ID.
    raise ProductNotFoundError, "Product with ID #{id} cannot found."
  end

  def self.destroy(id)
    # destroy: Delete the product corresponding to the given id from the 
    #          database, and return a Product object for the product that was deleted.
    # parameter: id -> the target id to destroy
    
    # Read through our database for further iteration
    data = CSV.read(@@TOYDATABASE)
    cnt = 0
    
    # Iterate through database to test whether the record we got equals to the ID we want
    data.each_with_index do |instance, cnt|
      product = new(id: instance[0], brand: instance[1], name: instance[2], price: instance[3])
      
      # Found the recode, destroy and update the database.
      if product.id == id
        data.delete_at(cnt)
        CSV.open(@@TOYDATABASE, 'wb') do |csv|
          data.each do |record|
            csv << record
          end
        end
        return product
      end
    end
    
    # If the ID we want is not able to be found, ruby will execute this final line
    # This exception represents that we can't find the result with that ID.
    raise ProductNotFoundError, "Product with ID #{id} cannot found."
  end

  def self.where(options={})
    # where: return an array of Product objects that match a given brand or product name.
    # parameter: options -> with name and brand saved in this dictionary
    target = nil
    target_str = ""

    # Determine whether we should use brand or name to select our results.
    if options[:brand]
      target_str = 'brand'
      target = :brand
    elsif options[:name]
      target_str = 'name'
      target = :name
    end

    # Iterate through the database to compare with the value we have in order to pick out the results we want
    output = []
    self.all.each do |product_result|
      if product_result[target_str] == options[target]
        output.push(product_result)
      end
    end
    return output
  end

  def update(attributes)
    # update: change the information for a given Product object, and save the new data to the database.
    # parameter: attributes -> with brand, name, price saved in this dictionary
    data = CSV.read(@@TOYDATABASE)
    
    # Extract saved information from the dictionary we passed in
    @name = attributes[:name] ? attributes[:name] : @name
    @brand = attributes[:brand] ? attributes[:brand] : @brand
    @price = attributes[:price] ? attributes[:price] : @price

    # Construct an array for further csv written convenience 
    data.each do |instance|
      if @id == instance[0].to_i
        instance[1] = @brand
        instance[2] = @name
        instance[3] = @price
        break
      end
    end
    CSV.open(@@TOYDATABASE, 'wb') do |csv|
      data.each do |row|
        csv << row
      end
    end
    self
  end
end