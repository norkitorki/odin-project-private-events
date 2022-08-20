class AddPrivateToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :private, :integer, default: 0
  end
end
