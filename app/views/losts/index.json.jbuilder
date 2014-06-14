json.array!(@losts) do |lost|
  json.extract! lost, :id, :item_number, :bib_number, :title, :imprint, :isbn, :status, :checkouts, :location, :note, :call_number, :volume, :barcode, :due_date, :last_checkout
  json.url lost_url(lost, format: :json)
end
