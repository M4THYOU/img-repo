FactoryBot.define do
    factory :image_row do
        name { 'test.png' }
        after(:build) do |img_row|
            file = File.open(Rails.root.join('spec', 'factories', 'images', 'test.png'))
            img_row.image.attach(
                io: file,
                filename: File.basename(file),
                content_type: 'image/png',
                metadata: {:height => 340, :width => 544})
        end
    end
end