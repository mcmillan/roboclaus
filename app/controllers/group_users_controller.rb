class GroupUsersController < ApplicationController
  before_action :load_group
  before_action :load_group_user

  def destroy
    return redirect_to @group, alert: "You can't remove yourself" if @group_user.user.id == current_user.id

    @group_user.destroy!

    redirect_to @group
  end

  private

  def load_group
    @group = current_user.groups.find(params[:group_id])
  end

  def load_group_user
    @group_user = @group.group_users.find(params[:id])
  end
end
