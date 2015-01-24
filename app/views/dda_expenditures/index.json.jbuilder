json.array!(@dda_expenditures) do |dda_expenditure|
  json.extract! dda_expenditure, :id, :title, :paid, :fund, :paid_date
  json.url dda_expenditure_url(dda_expenditure, format: :json)
end
