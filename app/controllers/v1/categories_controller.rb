# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  # GET /categories
  def index
    render json: CategorySerializer.new(Category.all, index_options).serializable_hash
  end

  private

  def index_options
    {
      meta: { total: Category.count },
      links: { next: nil, prev: nil }
    }
  end
end
