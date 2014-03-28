json.array!(@lost_missing_long_overdues) do |lost_missing_long_overdue|
  json.extract! lost_missing_long_overdue, :id, :item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout
  json.url lost_missing_long_overdue_url(lost_missing_long_overdue, format: :json)
end
