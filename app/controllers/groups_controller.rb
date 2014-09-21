class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    if !current_user.groups.exists?(@group)
      redirect_to :action => "index"
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    current_user.groups << @group

    respond_to do |format|
      if @group.save && current_user.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /groups/1/new_user
  # GET /groups/1/new_user.json
  def new_user
    @group = current_user.groups.find(params[:id])
  end

  def email_new_user(email)
    m = Mandrill::API.new '1bIbtiJDlLgJjqw4YuPegw'
    body = "Your roommate invited you to join Room Mate"
  message = {  
   :subject=> body,  
   :from_name=> "Room Mate",  
   :text=>body + " too bad we're exclusive. :(",  
   :to=>[  
     {  
       :email=> email,  
       :name=> "Friend"  
     }  
   ],  
   :html=>"<html> #{body} </html>",  
   :from_email=>"roommate@noreply.com"  
  }  
  sending = m.messages.send message  
  puts sending
  end

  # POST /groups/add_user
  # POST /groups/add_user.json
  def add_user
    @group = current_user.groups.find(params[:group_id])
    @user = User.find_by_email(params[:email])

    if @user
      @user.groups << @group
      respond_to do |format|
      if @user.save
        format.html { redirect_to @group, notice: 'User was successfully added.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
    else
      email_new_user(params[:email])
      respond_to do |format|
        format.html { redirect_to @group, notice: 'User was notified through email.'}
        format.json { render action: 'show', status: :created, location: @group }
      end  
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    current_user.groups.delete(@group)
    current_user.save
    if @group.users.count == 0
      @group.destroy
    end
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description)
    end
end
