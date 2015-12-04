class RenameLanguageColumn < ActiveRecord::Migration
  def change
  	rename_column :orders, :lang, :language
  end
end
