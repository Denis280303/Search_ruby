# frozen_string_literal: true

class SearchService
  def initialize(search_params)
    @name = search_params[:name]
    @type = search_params[:type]
    @designer = search_params[:designer]
    @exclusions = search_params[:exclusions]
  end

  # In this method, we load data from a JSON file and
  # generate the result with exceptions, if they are specified
  def call
    data = load_data
    results = data

    results = filter_by(results, 'Name', name)
    results = filter_by(results, 'Type', type)
    results = filter_by(results, 'Designed by', designer)
    exclude_results(results, exclusions)
  end

  private

  attr_accessor :name, :type, :designer, :exclusions

  # Method for checking whether the specified word in the query is one or several of them.
  # If there are several words, we calculate all the combinations, because
  # if the words are not in the correct order, we still need to get the correct result
  def filter_by(results, key, value)
    return results unless value.present?

    results.select do |item|
      if words_in_query(value).length < 2
        item[key].downcase.include?(value.to_s.strip.downcase)
      else
        with_different_sequences?(item, calculate_combinations(value).flatten, key)
      end
    end
  end

  def calculate_combinations(value)
    length = words_in_query(value).length
    combinations = []

    words_in_query(value).combination(length).each do |combo|
      combinations << [combo.join(' '), combo.reverse.join(' ')].uniq
    end
    combinations
  end

  def words_in_query(value)
    @_words_in_query = value.split
  end

  # If there are words in the field for negative queries - we remove the results with unwanted words
  def exclude_results(results, exclusions)
    return results unless exclusions.present?

    results.reject do |item|
      exclusions.split(',').any? { |exclusion| item.values.to_s.include?(exclusion.strip) }
    end
  end

  def load_data
    JSON.parse(File.read(Rails.root.join('lib', 'data.json')))
  end

  def with_different_sequences?(item, field, key)
    field.any? { |n| item[key].downcase.include?(n.downcase.strip) }
  end
end
