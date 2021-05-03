FactoryBot.define do
    factory :image_search_index do
        record_id { 1 }
        filename { 'test.png' }
        content_type { 'image/png' }
        height { 100 }
        width { 100 }
        byte_size { 100 }
        created_at { DateTime.now }
    end
end
