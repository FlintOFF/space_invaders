class CreateRadars < ActiveRecord::Migration[5.2]
  def change
    create_table :radars do |t|
      t.string :title
      t.string :description
      t.integer :frame_height
      t.integer :frame_width
      t.text :frame_symbols, array: true, default: []
      t.timestamps
    end
  end
end
