require 'rails_helper'

RSpec.describe ImageRow, type: :model do
    describe 'bulk action' do
        let!(:row1) { described_class.create!(name: 'test_1') }
        let!(:row2) { described_class.create!(name: 'test_2') }
        let!(:row3) { described_class.create!(name: 'test_3') }
        let!(:image_ids) { [row1.id, row2.id, row3.id] }
        let!(:images) { described_class.where(id: image_ids, is_deleted: false).to_a }
        # Undelete each row after each example.
        after(:each) {
            row1.is_deleted = true
            row2.is_deleted = true
            row3.is_deleted = true
            row1.save
            row2.save
            row3.save
        }

        context 'no selected images' do
            it 'should not perform any action' do
                action = described_class.bulk_actions[:select]
                res = described_class.perform_bulk_action(action, [])
                expect(res).to eq('Action not implemented.')
            end
            it 'should not delete any images' do
                action = described_class.bulk_actions[:delete]
                res = described_class.perform_bulk_action(action, [])
                expect(res).to eq('Images deleted.')
                new_images = described_class.where(id: image_ids, is_deleted: false).to_a
                expect(new_images).to eq(images)
            end
        end

        context '1+ selected images' do
            it 'should not perform any action' do
                action = described_class.bulk_actions[:select]
                res = described_class.perform_bulk_action(action, image_ids)
                expect(res).to eq('Action not implemented.')
                new_images = described_class.where(id: image_ids, is_deleted: false).to_a
                expect(new_images).to eq(images)
            end
            it 'should delete all the images' do
                action = described_class.bulk_actions[:delete]
                res = described_class.perform_bulk_action(action, image_ids)
                expect(res).to eq('Images deleted.')
                new_images = described_class.where(id: image_ids, is_deleted: false).to_a
                expect(new_images).to eq([])
            end
        end

    end
end
