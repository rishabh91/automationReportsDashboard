class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :module
      t.integer :passed
      t.integer :failed
      t.integer :total

      t.timestamps null: false
    end
  end
end
