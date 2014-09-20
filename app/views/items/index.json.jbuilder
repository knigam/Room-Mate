json.array!(@items) do |item|
  json.extract! item, :id, :name, :number, :priority, :last_user
  json.url item_url(item, format: :json)
end
