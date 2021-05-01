require 'rails_helper'

RSpec.describe Search::Index do

    describe 'index_one' do
        let(:img_row) { FactoryBot.create(:image_row) }

        it 'should create an index record' do
            before_count = ImageSearchIndex.count
            expect(before_count).to eq(0)
            described_class.index_one(img_row)
            expect(ImageSearchIndex.count).to eq(1)

            indexed_row = ImageSearchIndex.find_by(record_id: img_row.id)
            expect(indexed_row).to_not be_nil
            expect(indexed_row.filename).to eq('test.png')
            expect(indexed_row.content_type).to eq('image/png')
            expect(indexed_row.height).to eq(340)
            expect(indexed_row.width).to eq(544)
            expect(indexed_row.byte_size).to eq(38411)
        end

    end

end
