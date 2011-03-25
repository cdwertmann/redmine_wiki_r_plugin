class RenameHash < ActiveRecord::Migration
  def self.up
    rename_column :wiki_rs, :hash, :image_id
    add_index :wiki_rs, :image_id, :name => :wiki_rs_image_id
  end

  def self.down
    rename_column :wiki_rs, :image_id, :hash
  end
end
