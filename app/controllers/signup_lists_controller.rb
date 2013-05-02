class SignupListsController < ApplicationController
  before_filter :require_user

  def index
    @signup_lists = SignupList.order('signup_date DESC').all

    respond_to do |format|
      format.html
      format.json { render json: @signup_lists }
    end
  end

  def show
    @signup_list = SignupList.find(params[:id].to_i)

    respond_to do |format|
      format.html
      format.json { render json: @signup_list }
    end
  end

  def new
    @signup_list = SignupList.new

    respond_to do |format|
      format.html
      format.json { render json: @signup_list }
    end
  end
  
  def new_for
    @points_entry_type = PointsEntryType.find(params[:type_id].to_i)
    @signup_list = SignupList.new
    @signup_list.points_entry_type = @points_entry_type

    render action: "new"
  end

  def edit
    @signup_list = SignupList.find(params[:id].to_i)
  end

  def create
    @signup_list = SignupList.new(params[:signup_list])

    respond_to do |format|
      if @signup_list.save
        format.html { redirect_to @signup_list, notice: 'Signup List created' }
        format.json { render json: @signup_list, status: :created, location: @signup_list }
      else
        format.html { render action: "new" }
        format.json { render json: @signup_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @signup_list = SignupList.find(params[:id].to_i)

    respond_to do |format|
      if @signup_list.update_attributes(params[:signup_list])
        format.html { redirect_to @signup_list, notice: 'Signup List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @signup_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
