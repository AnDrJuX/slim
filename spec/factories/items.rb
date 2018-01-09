FactoryBot.define do
  factory :item do
    title "my string"
    body "my text"
  end

  factory :invalid_item, class: "Item" do
    title nil
    body nil
  end
end
