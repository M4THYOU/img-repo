class ImageRow < ApplicationRecord
    has_one_attached :image

    enum bulk_action: [:select, :delete], _prefix: true

end
