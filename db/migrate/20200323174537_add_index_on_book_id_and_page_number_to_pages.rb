class AddIndexOnBookIdAndPageNumberToPages < ActiveRecord::Migration[6.0]
  def change
    add_index :pages, [:book_id, :page_number], unique: true
  end
end
