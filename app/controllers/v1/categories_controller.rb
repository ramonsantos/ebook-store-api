# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  include JSONAPI::Deserialization

  # GET /categories
  def index
    render json: CategorySerializer.new(Category.all, index_options).serializable_hash
  end

  # PUT /categories/:category_code
  def update
    category.update!(jsonapi_deserialize(params, only: [:code, :name]))

    render json: category, status: :no_content
  rescue ActiveRecord::RecordInvalid => e
    raise ApiError.new(:bad_request, { record: e.record })
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
  rescue ActiveRecord::RecordNotFound => e
    raise ApiError.new(:not_found, { model: e.model, identifier: params[:category_code] })
  end

  def category_params
    params.require(:category).permit(:name, :code)
  end

  def index_options
    {
      meta: { total: Category.count },
      links: { next: nil, prev: nil }
    }
  end
end
