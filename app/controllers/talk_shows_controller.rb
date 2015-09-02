class TalkShowsController < ApplicationController
  include ShowsController

  # GET /talk_shows
  # GET /talk_shows.json
  def index
    @talk_shows = TalkShow.all
  end

  # GET /talk_shows/1
  # GET /talk_shows/1.json
  def show
  end

  # GET /talk_shows/new
  def new
    @talk_show = TalkShow.new
  end

  # GET /talk_shows/1/edit
  def edit
    authorize_action_for @talk_show
  end

  # POST /talk_shows
  # POST /talk_shows.json
  def create
    @talk_show = TalkShow.new(talk_show_params)
    @talk_show.dj = Dj.find(params[:talk_show][:dj_id]) unless params[:talk_show][:dj_id].blank?
    @talk_show.semester = Semester.find(params[:semester_id])
    @talk_show.set_times_conditionally_from_params params[:talk_show]

    respond_to do |format|
      if @talk_show.save
        format.html { redirect_to edit_semester_path(@talk_show.semester, anchor: "tab-talk") }
      else
        format.html do
          flash[:alert] = @talk_show.errors.full_messages
          session[:talk_show] = @talk_show
          redirect_to edit_semester_path(params[:semester_id], anchor: "tab-talk")
        end
      end
    end
  end

  # PATCH/PUT /talk_shows/1
  # PATCH/PUT /talk_shows/1.json
  def update
    authorize_action_for @talk_show

    @talk_show.dj = Dj.find(params[:talk_show][:dj_id]) unless params[:talk_show][:dj_id].blank?
    @talk_show.set_times_conditionally_from_params params[:talk_show]

    respond_to do |format|
      if @talk_show.update(talk_show_params)
        format.html { redirect_to @talk_show, notice: 'Talk show was successfully updated.' }
        format.json { render :show, status: :ok, location: @talk_show }
      else
        format.html { render :show }
        format.json { render json: @talk_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /talk_shows/1
  # DELETE /talk_shows/1.json
  def destroy
    @talk_show.destroy
    respond_to do |format|
      format.html { redirect_to talk_shows_url, notice: 'Talk show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
