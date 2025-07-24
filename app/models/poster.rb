class Poster
  ITUNES_WIDTH = 400
  TEXT_WIDTH = 380
  TEXT_ALIGNMENT = Magick::CenterGravity
  FONT_SIZE = 48
  FONT_FAMILY = 'helvetica'
  FONT_COLOR = "#dee0e6"
  FONT_WEIGHT = Magick::BoldWeight


  def self.generate(poster_name)
    img = Magick::ImageList.new(Rails.root.join("public", "img", "blank.png"))
    text = Magick::Draw.new
    message = self.add_word_wrap(poster_name, TEXT_WIDTH)

    img.annotate(text, 0,0,0,0, message) do
      text.gravity = TEXT_ALIGNMENT
      text.pointsize = FONT_SIZE
      text.fill = FONT_COLOR
      text.font_family = FONT_FAMILY
      text.font_weight = FONT_WEIGHT
      img.format = "png"
    end

    img
  end

  def self.add_word_wrap(message, max_width)
    words = message.split(' ')

    wrapped = ''

    words.each do |w|
      if can_fit?("#{wrapped} #{w}", max_width)
        wrapped = "#{wrapped} #{w}"
      else
        wrapped = "#{wrapped}\n#{w}"
      end
    end

    wrapped
  end

  def self.can_fit?(message, max_width)
    img = Magick::Image.new(max_width, max_width)
    text = Magick::Draw.new

    img.annotate(text, 0,0,0,0, message) do
      text.gravity = TEXT_ALIGNMENT
      text.pointsize = FONT_SIZE
      text.fill = FONT_COLOR
      text.font_family = FONT_FAMILY
      text.font_weight = FONT_WEIGHT
    end
    metrics = text.get_multiline_type_metrics(img, message)
    (metrics.width < max_width)
  end
end