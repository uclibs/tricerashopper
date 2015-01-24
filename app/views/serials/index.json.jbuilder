json.array!(@serials) do |serial|
  json.extract! serial, :id
  json.url serial_url(serial, format: :json)
end
