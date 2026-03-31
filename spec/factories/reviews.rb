FactoryBot.define do
  factory :review do
    score { rand(1..5) }
    user
    book
  end
end
