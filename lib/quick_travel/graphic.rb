module QuickTravel
  class Graphic
    attr_accessor :thumbnails, :image_uid

    def initialize(g)
      @image_uid = g['image_uid']
    end

    def path(thumbnail_name)
      result = @thumbnails.find_all { |t| t['thumbnail'] == thumbnail_name.to_s }
      '/media/cache/' + result.first['filename'] unless result.blank?
    end

    def url(thumbnail_name)
      QuickTravel.url + path(thumbnail_name)
    end
  end
end
