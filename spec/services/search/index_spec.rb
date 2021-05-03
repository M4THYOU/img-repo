require 'rails_helper'

RSpec.describe Search::Index do

    describe 'index_one' do
        it 'should create an index record' do
            img_row = FactoryBot.create(:image_row)
            expect(ImageSearchIndex.count).to eq(0)
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
        it 'should update an index record' do
            img_row = FactoryBot.create(:image_row)
            # index it
            described_class.index_one(img_row)
            expect(ImageSearchIndex.count).to eq(1)
            indexed_row = ImageSearchIndex.find_by(record_id: img_row.id)
            expect(indexed_row.width).to eq(544)
            # make change
            img_row.image.metadata["width"] = 900
            img_row.save
            described_class.index_one(img_row)
            # reindex it
            indexed_row = ImageSearchIndex.find_by(record_id: img_row.id)
            expect(indexed_row.width).to eq(900)
        end
    end

    describe 'un_index_one' do
        it 'should remove the index for a record' do
            img_row = FactoryBot.create(:image_row)
            # index it
            expect(ImageSearchIndex.count).to eq(0)
            described_class.index_one(img_row)
            expect(ImageSearchIndex.count).to eq(1)
            indexed_row = ImageSearchIndex.find_by(record_id: img_row.id)
            expect(indexed_row).to_not be_nil
            # un index it
            described_class.un_index_one(img_row)
            expect(ImageSearchIndex.count).to eq(0)
            indexed_row = ImageSearchIndex.find_by(record_id: img_row.id)
            expect(indexed_row).to be_nil
        end
    end

    describe 'clean_index' do
        it 'should remove all hanging indices' do
            expect(ImageSearchIndex.count).to eq(0)
            expect(ImageRow.count).to eq(0)
            img_row1 = FactoryBot.create(:image_row)
            img_row2 = FactoryBot.create(:image_row)
            described_class.index_one(img_row1)
            described_class.index_one(img_row2)
            expect(ImageSearchIndex.count).to eq(2)
            expect(ImageRow.count).to eq(2)
            img_row1.destroy
            expect(ImageSearchIndex.count).to eq(2)
            expect(ImageRow.count).to eq(1)
            described_class.clean_index
            expect(ImageSearchIndex.count).to eq(1)
            expect(ImageRow.count).to eq(1)
        end
        it 'should index all un indexed rows' do
            expect(ImageSearchIndex.count).to eq(0)
            expect(ImageRow.count).to eq(0)
            FactoryBot.create(:image_row)
            FactoryBot.create(:image_row)
            expect(ImageSearchIndex.count).to eq(0)
            expect(ImageRow.count).to eq(2)
            described_class.clean_index
            expect(ImageSearchIndex.count).to eq(2)
            expect(ImageRow.count).to eq(2)
        end
    end

end
