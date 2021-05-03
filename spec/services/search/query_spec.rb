require 'rails_helper'

RSpec.describe Search::Query, type: :model do
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    before(:each) {
        FactoryBot.create(:image_search_index, filename: 'abc.png', content_type: 'image/jpeg',
                          height: 560, width: 1001, byte_size: 14325434, created_at: DateTime.new(2001, 06, 26))
        FactoryBot.create(:image_search_index, content_type: 'some_other type', created_at: DateTime.new(2021, 4, 25))
        FactoryBot.create(:image_search_index, height: 101, created_at: DateTime.new(2001, 4, 25, 9))
        FactoryBot.create(:image_search_index, width: 101, created_at: DateTime.new(2001, 4, 25, 9, 30, 21))
        FactoryBot.create(:image_search_index, created_at: DateTime.new(2020, 01, 03))
        FactoryBot.create(:image_search_index, byte_size: 44444, created_at: DateTime.new(2001, 4, 25, 9, 30, 23))
    }

    describe 'class initialization' do
        it 'should initialize a default query and return all results' do
            query = described_class.new
            expect(query).to be_instance_of(described_class)
            results = query.search
            expect(results.count).to be(6)
        end
    end

    describe 'search query' do
        it 'should matching on the string query' do
            q = described_class.new(query: 'abc.png')
            expect(q.search.count).to be(1)
            q.query = 'test.png'
            expect(q.search.count).to be(5)
            q.query = 'image/jpeg'
            expect(q.search.count).to be(1)
            q.query = 'some_other type'
            expect(q.search.count).to be(1)
            q.query = 'image/png'
            expect(q.search.count).to be(4)
            q.query = 'no match :('
            expect(q.search.count).to be(0)
        end
        it 'should match on height and width' do
            q = described_class.new(height_op: '<', height: 2)
            expect(q.search.count).to be(0)
            q.height = 100
            expect(q.search.count).to be(4)
            # TODO: MORE TESTS
        end
        it 'should match on byte size' do
            #
        end
        it 'should match on creation date' do
            #
        end
    end

end