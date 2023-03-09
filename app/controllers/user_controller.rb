class UserController < ApplicationController
    before_action :set_user, except: [:all]
    before_action :login_required, except: [:all]
    before_action :user_quota, except: [:all, :show]
    HITS_LIMIT = 100000



    def set_user
       # Perfrom various authentication tecchnique with jwt
      #  @current_user ||= User.includes(:monthly_hits).find(params[:id].to_i) if params[:id] -- This takes too much time.
      @current_user ||= User.find_by_id(params[:id].to_i) if params[:id]
    end

    def login_required
        render  json: { error: 'invalid user' } if @current_user.nil?
    end

    def user_quota
        @current_user.update!(time_zone: params[:time_zone]) if params[:time_zone]
        render json: { error: 'over quota' } if @current_user.count_hits >= HITS_LIMIT
    end

    def hit_endpoint
      @current_user.hits.create!(endpoint: Faker::Internet.unique.url)
      render json: {data: @current_user.hits.limit(50)}
    end

  def show
    render json: @current_user, status: :ok
  end

  def all
    @users = User.all
    render json: @users, status: :ok
  end
end