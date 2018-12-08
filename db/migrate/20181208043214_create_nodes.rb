class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.integer :position
      t.integer :first_player_win, :default => 1
      t.integer :second_player_win, :default => 1
      t.timestamps
    end
  end
end
