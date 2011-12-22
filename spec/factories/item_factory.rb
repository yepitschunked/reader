Factory.sequence(:item_id)
FactoryGirl.define do
  factory :item do
    title 'title'
    content 'lorem ipsum'
    original_location 'test.test'
    item_id { Factory.next(:item_id) }
  end

  factory :unprocessed_item, :class => FeedNormalizer::Entry do
    title 'title'  
    content 'lorem ipsum'
    urls ['test.test']
    id { Factory.next(:item_id) }
  end
end
