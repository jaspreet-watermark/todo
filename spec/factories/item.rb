# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    title { Faker::Commerce.product_name }

    trait :valid do
      tags { [build(:tag, name: 'Bad'), build(:tag)] }
    end

    trait :invalid_tags do
      tags { [build(:tag), build(:tag)] }
    end
  end
end
