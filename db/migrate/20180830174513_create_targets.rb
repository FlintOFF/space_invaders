class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.references :radar, foreign_key: true
      t.string :title
      t.string :description
      t.column :kind, :integer, default: 0
      t.text :frame, array: true, default: []
      t.timestamps
    end
  end
end
