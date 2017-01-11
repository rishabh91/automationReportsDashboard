class AddFailedCasesToReport < ActiveRecord::Migration
  def change
    add_column :reports, :failed_cases, :string
  end
end
