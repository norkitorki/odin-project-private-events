class RenameEventsDateToStartDate < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :date, :start_date
  end
end
