class RenameLanguageColumn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :lang, :language
  end
end
