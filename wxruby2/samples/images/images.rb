# wxRuby2 Sample Code. Copyright (c) 2004-2006 Kevin B. Smith
# Freely reusable code: see SAMPLES-LICENSE.TXT for details

require 'wx'

class MyFrame < Wx::Frame
  def initialize(title)
    super(nil, -1, title)
    evt_paint do onPaint end
    image = Wx::Image.new('paperclip.png')
    @bitmap = Wx::Bitmap.new(image)
  end

  def onPaint
    puts("onPaint begin")
    paint do | dc |
	dc.clear
	dc.draw_bitmap(@bitmap, 0, 0, false)
    end
    puts("onPaint end")
  end
end

class ImagesApp < Wx::App
  def on_init
    frame = MyFrame.new("Simple Image Demo")
	frame.show
  end
end

Wx::init_all_image_handlers
a = ImagesApp.new
a.main_loop()
