class CreateTbChanges < ActiveRecord::Migration
  def self.up
    create_table :tb_changes do |t|
    end
  end

  def self.down
    drop_table :tb_changes
  end
end
