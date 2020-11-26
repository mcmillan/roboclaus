class GroupsController < ApplicationController
  before_action :load_group, except: %i[index new create]

  def index
    redirect_to new_group_path if current_user.groups.none?
    redirect_to current_user.groups.first if current_user.groups.one?

    @groups = current_user.groups
  end

  def show
    redirect_to @group if request.path != group_path(@group)
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)
    @group.group_users << GroupUser.new(user: current_user)

    if @group.save
      redirect_to @group
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group updated!'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def match
    @group.match!
    redirect_to @group
  end

  private

  def load_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :budget, :deadline)
  end
end
