class ImageRow < ApplicationRecord
    has_one_attached :image

    enum bulk_action: [:select, :delete], _prefix: true

    class << self

        # @param action [Symbol] A symbol representing the bulk_action to perform.
        # @param images [Array<Integer>] Array of IDs for each image_row to perform the action on.
        # @return [String] the flash message to display.
        def perform_bulk_action(action, images)
            # We are using an is_deleted flag on the image row for deletion to accommodate for recovery of "deleted" data.
            # In a production environment, we would likely run a scheduled job to actually delete images which have had
            #   is_deleted = true for >= a specified period of time, to keep the DB clean.
            if action.to_i == bulk_actions[:delete]
                update_vals = {is_deleted: true}
                img_rows = where(id: images)
                img_rows.update_all(update_vals)
                Search::Index.un_index_many(images)
                'Images deleted.'
            else
                'Action not implemented.'
            end
        end

    end

end
