# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  # GET /categories
  def index
    render json: CategorySerializer.new(Category.all, index_options).serializable_hash
  end

  # DELETE /categories/1
  def destroy
    return render_error if category.blank?

    category.destroy
    render nothing: true, status: :no_content
  end

  private

  def category
    @category ||= Category.find_by(code: params[:category_code])
  end

  def index_options
    {
      meta: { total: Category.count },
      links: { next: nil, prev: nil }
    }
  end

  def render_error
    render json: { errors: [{ title: "Category '#{params[:category_code]}' not found" }] }, status: :not_found
  end
end
