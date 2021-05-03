module Search
    # Search::Index handles all indexing for new uploads and deletions.
    module Index
        include Service

        class << self
            # Indexes the given image_row or updates the existing one.
            # @param img_row [ImageRow]
            def index_one(img_row)
                val = {
                    record_id: img_row.id,
                    filename: img_row.image.filename.to_s,
                    content_type: img_row.image.content_type,
                    height: img_row.image.metadata[:height],
                    width: img_row.image.metadata[:width],
                    byte_size: img_row.image.byte_size,
                    created_at: img_row.image.created_at
                }
                existing_index = ImageSearchIndex.find_by(record_id: img_row.id)
                if existing_index.nil?
                    ImageSearchIndex.create!(val)
                else
                    ImageSearchIndex.update(val)
                end
            end

            # Removes index for the given image_row, usually on deletion.
            # @param img_row [ImageRow]
            def un_index_one(img_row)
                ImageSearchIndex.find_by(record_id: img_row.id).destroy
            end

            # Deletes the indexes for the specified array of image row ids.
            # @param img_row_ids [Array<Integer>]
            def un_index_many(img_row_ids)
                ImageSearchIndex.where(record_id: img_row_ids).destroy_all
            end

            # Calls remove_hanging_indices then index_all to keep the search index up to date.
            # In a prod environment, we would never manually call this method. Instead, use a job scheduler like Sidekiq
            #   to periodically (say every 24 hrs, for arguments sake) to automatically clean out the index.
            def clean_index
                remove_hanging_indices
                index_all
            end

            private

            # Checks all the image_rows and creates an index entry for each unindexed one.
            def index_all
                ImageRow.find_each.each do |row|
                    index_one(row)
                end
            end

            # Checks all image_rows against the current search index. Remove indices for deleted image rows.
            def remove_hanging_indices
                ImageSearchIndex.select(:id, :record_id).find_each.each do |idx|
                    row = ImageRow.find_by(id: idx.record_id)
                    if row.nil?
                        idx.destroy
                    end
                end
            end
        end

    end
end
