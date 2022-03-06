# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    association :user
    start_time { 1.day.from_now.change(hour: 12) }
    end_time { 1.day.from_now.change(hour: 14) }

    trait :with_host do
      association :host
    end

    trait :provisional_approved_user do
      state { 'provisional' }
      association :user, factory: [:user, :approved]
      association :host, factory: :host
    end

    trait :provisional_unapproved_user do
      state { 'provisional' }
      association :user, factory: :user
    end

    trait :confirmed do
      state { 'confirmed' }
      confirmed_at { Time.current }
      association :confirmed_by, factory: :user
    end

    trait :cancelled do
      state { 'cancelled' }
    end

    trait :provisional_approved_user_expired do
      state { 'provisional' }
      association :user, factory: [:user, :approved]
      start_time { DateTime.now - 2.days }
    end

    trait :confirmed_approved_user do
      state { 'confirmed' }
      confirmed_at { Time.current }
      association :confirmed_by, factory: :user
      association :user, factory: [:user, :approved]
    end

    trait :cancel_approved_user do
      state { 'cancelled' }
      association :user, factory: [:user, :approved]
    end
  end
end
