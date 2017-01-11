class AddDepdateToReport < ActiveRecord::Migration
  def change
    add_column :reports, :depdate, :date
  end
end
