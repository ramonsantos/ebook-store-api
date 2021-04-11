# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  include JSONAPI::Deserialization

  before_action :required_params, only: [:create]

  # GET /categories
  def index
    render json: CategorySerializer.new(Category.all, index_options).serializable_hash
  end

  # POST /categories
  def create
    category = Category.create!(category_params)

    render json: CategorySerializer.new(category).serializable_hash, status: :created
  end

  # PUT /categories/:category_code
  def update
    category.update!(category_params)

    render json: category, status: :no_content
  end

  # DELETE /categories/:category_code
  def destroy
    category.destroy

    render nothing: true, status: :no_content
  end

  private

  def category
    @category ||= find_category
  end

  def find_category
    Category.find_by!(code: params[:category_code])
  end

  def category_params
    params.require(:data).require(:attributes).permit(:code, :name)
  end

  def index_options
    {
      meta: { total: Category.count },
      links: { next: nil, prev: nil }
    }
  end

  def required_params
    [:code, :name].each do |required_param|
      category_params.require(required_param)
    end
  end
end
