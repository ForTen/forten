FactoryGirl.define do
  factory :wonjae, class: User do |f|
    f.username "akkiros"
    f.email "test@test.com"
    f.password "99e193ca18e3084feeafc86561d2b12ba4bbc04f"
  end

  factory :minsoo, class: User do |f|
    f.username "minsoo1003"
    f.email "test2@test.com"
    f.password "99e193ca18e3084feeafc86561d2b12ba4bbc04f"
  end
end
