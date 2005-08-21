require 'wx'

SHOW_BACKGROUND = 0

module Demo

class MyParentFrame < Wx::MDIParentFrame
    def initialize()
        super(nil, -1, "MDI Parent", Wx::DEFAULT_POSITION, Wx::Size.new(600,400))
        
        @winCount = 0
        menu = Wx::Menu.new()
        menu.append(5000, "&New Window")
        menu.append_separator()
        menu.append(5001, "E&xit")
        
        menubar = Wx::MenuBar.new()
        menubar.append(menu, "&File")
        set_menu_bar(menubar)
        
        create_status_bar()
        
        evt_menu(5000) {|event| on_new_window(event)}
        evt_menu(5001) {|event| on_exit(event)}
        
        if SHOW_BACKGROUND
            @bg_bmp = 
            evt_erase_background {|event| on_erase_background(event)}
        end
        load "wxScrolledWindow.rbw"
    end
    
    def on_exit(event)
        close()
    end
    
    def on_new_window(event)
        @winCount += 1
        win = Wx::MDIChildFrame.new(self, -1, "Child Window: " + @winCount.to_s())
        canvas = MyCanvas.new(win)
        win.show()
    end
end
    
end

