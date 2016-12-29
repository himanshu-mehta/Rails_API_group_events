class GroupEventsController < ApplicationController
  before_action :set_group_event, only: [:show, :update, :destroy, :show_publishable]

  # GET /group_events
  def index
    @group_events = GroupEvent.all
    render json: @group_events
  end

  # GET users/1/group_events/1
  def show
    render json: @group_event
  end

  # POST users/1/group_events
  def create
    @user = User.find(params[:user_id])
    @group_event = @user.group_events.build(group_event_params)
    if @group_event.save
      render json: @group_event, status: :created
    else
      render json: @group_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT users/1/group_events/1
  def update
    if @group_event.update(group_event_params)
      render json: @group_event
    else
      render json: @group_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE users/1/group_events/1
  def destroy
    binding.pry
    @group_event.each do |event|
      event.removed = true
      event.save
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_event
    	@user = User.find(params[:user_id])
      @group_event = @user.group_events
    end

    # Only allow a trusted parameter "white list" through.
    def group_event_params
      params.require(:group_event).permit(:duration, :start_time, :name, :description, :location, :user_id)
    end
end
