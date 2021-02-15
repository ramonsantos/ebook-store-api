# frozen_string_literal: true

class V1::CategoriesController < ApplicationController
  # GET /categories
  def index
    render json: CategorySerializer.new(Category.all, index_options).serializable_hash
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
    @category ||= Category.find_by!(code: params[:category_code])
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
