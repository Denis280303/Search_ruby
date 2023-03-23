# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @results = SearchService.new(search_params).call

    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  def search_params
    params.permit(:name, :type, :designer, :exclusions)
  end
end
