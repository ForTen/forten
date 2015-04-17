FactoryGirl.define do
  factory :sad_comment, class: Comment do |f|
    f.body "댓글을 삭제합니다. 아..안되잖아..?"
  end
end
