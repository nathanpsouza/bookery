class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end
    add_index :books, :slug, unique: true
  end
end
