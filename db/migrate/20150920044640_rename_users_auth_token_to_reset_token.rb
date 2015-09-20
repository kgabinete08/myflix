class RenameUsersAuthTokenToResetToken < ActiveRecord::Migration
  def change
    rename_column :users, :auth_token, :reset_token
  end
end
