class ReviewsController < ApplicationController
    load_and_authorize_resource param_method: :review_params
    
    def index
        # @reviews = Review.order_by_time.page(params[:page]).per 9
        @reviews = Review.all.group_by{|review| review.created_at.strftime('%Y-%m-%d')}
        @reviews = @reviews.sort_by{ |day, _review| day }
        @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(4)
    end
    
    def new
        @review = Review.new
    end
    
    def create
        @review = current_user.reviews.build review_params
        if @review.save
          flash[:success] = "レビューを投稿しました"
          redirect_to @review
        else
          render :new
        end
    end
        
    def show; end
        
    def edit; end
        
    def update
        if @review.update_attributes review_params
          flash[:success] = "レビューを編集しました"
          redirect_to @review
        else
          render :edit
        end
    end
        
    def destroy
        @review.destroy
        flash[:success] = "レビューを削除しました"
        redirect_to reviews_url
    end

    private
        def review_params
            params.require(:review).permit :title, :content
        end
end