
require 'wxruby'
include Wx

MENU_FILE_OPEN = 100
MENU_FILE_SAVE = 101
MENU_FILE_QUIT = 102
MENU_EDIT_GOTO = 103
MENU_OPTION_BACKGROUND = 104
MENU_OPTION_FONT = 105
MENU_OPTION_DIRECTORY = 106
MENU_INFO_ABOUT = 107


class RangeValidator < Validator

  def initialize(value,min=nil,max=nil)
    super()
    if(min==nil && max==nil)
      Copy(value)
    else
      @m_min = min
      @m_max = max
      @m_value = value
    end
  end

  def m_min
    @m_min
  end
  def m_max
    @m_max
  end
  def m_value
    @m_value
  end

  def Clone
    return RangeValidator.new(self)
  end

  def Copy(val)
    @m_min   = val.m_min
    @m_max   = val.m_max
    @m_value = val.m_value
    return true
  end

  def Validate(parent)
    win = get_window()
    return false if !win
    control = win
    result = false

    currentValue = control.get_value

    if !currentValue.ToLong(value)
      message = sprintf(message,"%s is not a valid number", currentValue.c_str())
    else
      if value < m_min || value > m_max
          message = sprintf(message,"%ld is not between %ld and %ld", value, m_min, m_max)
      else
          result = true
      end
    end

    if !result
      MessageBox(message)
      control.set_focus
    end

    return result
  end

  def TransferToWindow

    win = get_window()
    return false if !win
    return false if !@m_value
    return false if !win.is_kind_of(CLASSINFO(TextCtrl))

    control = win
    control.set_value(@m_value)

    return true
  end

  def TransferFromWindow
    win = get_window()
    return false if !win
    return false if !@m_value

    return false if !win.is_kind_of(CLASSINFO(TextCtrl))

    control = win
    m_value = control.get_value

    return true
  end
end

class GotoLineDialog < Dialog
  def initialize(parent)
    super(parent, -1, "Goto Line...", DEFAULT_POSITION,
               Size.new(250, 120), DEFAULT_DIALOG_STYLE)
    @m_lineNumber = "1"
    set_auto_layout(TRUE)

    layout = LayoutConstraints.new

    # Label is centered on the dialog and on top of the dialog.
    @m_pLabel = StaticText.new(self, -1, "")
    layout.top.same_as(self, LAYOUT_TOP, 10)
    layout.centre_x.same_as(self, LAYOUT_CENTRE_X)
    layout.width.as_is
    layout.height.as_is
    @m_pLabel.set_constraints(layout)

    # LineNumberCtrl is centered on the dialog and below Label.
    @m_pLineNumberCtrl = TextCtrl.new(self, -1)
    layout = LayoutConstraints.new
    layout.top.below(@m_pLabel, 10)
    layout.centre_x.same_as(self, LAYOUT_CENTRE_X)
    layout.width.absolute(70)
    layout.height.as_is
    @m_pLineNumberCtrl.set_constraints(layout)

    # cancelButton is put at the right and bottom of the dialog.
    cancelButton = Button.new(self, ID_CANCEL, "Cancel")
    layout = LayoutConstraints.new
    layout.bottom.same_as(self, LAYOUT_BOTTOM, 10)
    layout.right.same_as(self, LAYOUT_RIGHT, 10)
    layout.width.as_is
    layout.height.as_is
    cancelButton.set_constraints(layout)

    # okButton is put at the left of the cancelButton.
    okButton = Button.new(self, ID_OK, "Ok")
    layout = LayoutConstraints.new
    layout.bottom.same_as(cancelButton, LAYOUT_BOTTOM)
    layout.right.left_of(cancelButton, 10)
    layout.width.same_as(cancelButton, LAYOUT_WIDTH)
    layout.height.as_is
    okButton.set_constraints(layout)

    evt_init_dialog {onInitDialog}
  end

  def onInitDialog
    label = @m_lineNumber
    label = sprintf(label,"Enter a line between 1 and %ld", @m_maxLineNumber)
    @m_pLabel.set_label(label)
    layout()
    rangeValidator = RangeValidator.new(@m_lineNumber, 1, @m_maxLineNumber)
    @m_pLineNumberCtrl.set_validator(rangeValidator)
    transfer_data_to_window()
    @m_pLineNumberCtrl.set_focus
  end

  def SetMaxLineNumber(maxLineNumber)
    @m_maxLineNumber = maxLineNumber
  end

  def GetLineNumber
    # Return 0 when toLong fails.
    return @m_lineNumber.to_i
  end
end

class AboutDialog < Dialog
  def initialize(parent)
    super(parent, -1, "About Simple Text Editor", DEFAULT_POSITION,
               Size.new(200, 200), DEFAULT_DIALOG_STYLE)
    set_auto_layout(TRUE)

    layout = LayoutConstraints.new

    layout.top.same_as(self, LAYOUT_TOP, 10)
    layout.centre_x.same_as(self, LAYOUT_CENTRE_X)
    layout.width.as_is
    layout.height.as_is
    @m_pInfoText = StaticText.new(self, -1, "", Point.new(-1, -1), DEFAULT_SIZE, ALIGN_CENTER)
    @m_pInfoText.set_constraints(layout)

    layout = LayoutConstraints.new
    layout.top.below(@m_pInfoText, 10)
    layout.centre_x.same_as(self, LAYOUT_CENTRE_X)
    layout.width.percent_of(self, LAYOUT_WIDTH, 80)
    layout.height.as_is

    @m_pOkButton = Button.new(self, ID_OK, "Ok", Point.new(-1, -1))
    @m_pOkButton.set_constraints(layout)

    layout()
  end

  def set_text(text)
    @m_pInfoText.set_label(text)
    # Call layout, because the static text could be resized.
    layout()
  end
end

class TextFrame < Frame
  def initialize(title, xpos, ypos, width, height)
    super(nil,-1, title, Point.new(xpos, ypos), Size.new(width, height))
    @m_pTextCtrl = TextCtrl.new(self, -1, "Type some text...",
	DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE)

    @m_pMenuBar = MenuBar.new

    # File Menu
    @m_pFileMenu = Menu.new
    @m_pFileMenu.append(MENU_FILE_OPEN, "&Open", "Opens an existing file")
    @m_pFileMenu.append(MENU_FILE_SAVE, "&Save", "Save the content")
    @m_pFileMenu.append_separator
    @m_pFileMenu.append(MENU_FILE_QUIT, "&Quit", "Quit the application")
    @m_pMenuBar.append(@m_pFileMenu, "&File")

    # Edit Menu
    @m_pEditMenu = Menu.new
    @m_pEditMenu.append(MENU_EDIT_GOTO, "&Goto Line", "Jump to a line")
    @m_pMenuBar.append(@m_pEditMenu, "&Edit")

    # Option Menu
    @m_pOptionMenu = Menu.new
    @m_pOptionMenu.append(MENU_OPTION_BACKGROUND, "&Background", "Sets the background colour of the editor")
    @m_pOptionMenu.append(MENU_OPTION_FONT, "&Font", "Sets the font of the editor")
    @m_pOptionMenu.append(MENU_OPTION_DIRECTORY, "&Directory", "Sets the working directory")
    @m_pMenuBar.append(@m_pOptionMenu, "&Options")

    # About menu
    @m_pInfoMenu = Menu.new
    @m_pInfoMenu.append(MENU_INFO_ABOUT, "&About", "Shows information about the application")
    @m_pMenuBar.append(@m_pInfoMenu, "&Info")

    set_menu_bar(@m_pMenuBar)

    # Statusbar
    create_status_bar(3)
    set_status_text("Ready", 0)

    evt_menu(MENU_FILE_OPEN) {|event| onMenuFileOpen(event) }
    evt_menu(MENU_FILE_SAVE) {|event| onMenuFileSave(event) }
    evt_menu(MENU_FILE_QUIT) {|event| onMenuFileQuit(event) }
    evt_menu(MENU_EDIT_GOTO) {|event| onMenuEditGoto(event) }
    evt_menu(MENU_INFO_ABOUT) {|event| onMenuInfoAbout(event) }
    evt_menu(MENU_OPTION_BACKGROUND) {|event| onMenuOptionBackgroundColor(event) }
    evt_menu(MENU_OPTION_FONT) {|event| onMenuOptionFont(event) }
    evt_menu(MENU_OPTION_DIRECTORY) {|event| onMenuOptionDirectory(event) }
    evt_close {|event| onClose(event) }
  end

  def onMenuFileOpen(event)
    dlg = FileDialog.new(self, "Open a text file",
		"", "", "All files(*.*)|*.*|Text Files(*.txt)|*.txt",
		OPEN, DEFAULT_POSITION)
    if dlg.show_modal == ID_OK
  	@m_pTextCtrl.load_file(dlg.get_filename)
	set_status_text(dlg.get_filename, 0)
    end
    dlg.destroy
  end

  def onMenuFileOpen(event)
    dlg = FileDialog.new(self, "Open a text file",
		"", "", "All files(*.*)|*.*|Text Files(*.txt)|*.txt",
		OPEN, DEFAULT_POSITION)
    if dlg.show_modal == ID_OK
	@m_pTextCtrl.load_file(dlg.get_filename)
	set_status_text(dlg.get_filename, 0)
    end
    dlg.destroy()
  end

  def onMenuFileSave(event)
    dlg = FileDialog.new(self, "Save a text file",
		"", "", "All files(*.*)|*.*|Text Files(*.txt)|*.txt",
		SAVE, DEFAULT_POSITION)
    if dlg.show_modal == ID_OK
	@m_pTextCtrl.save_file(dlg.get_path)
	set_status_text(dlg.get_filename, 0)
    end
    dlg.destroy
    @m_pTextCtrl.discard_edits
  end

  def onMenuFileQuit(event)
    close(FALSE)
  end

  def onMenuInfoAbout(event)
    dlg = AboutDialog.new(self)
    dlg.set_text("(c) 2001 S.A.W. Franky Braem\nSimple Text Editor\n")
    dlg.show_modal
    dlg.destroy
  end

  def onMenuEditGoto(event)
    dlg = GotoLineDialog.new(self)
    dlg.SetMaxLineNumber(@m_pTextCtrl.get_number_of_lines)
    if dlg.show_modal == ID_OK
	# Convert the linenumber to a position and set self as the new insertion point.
	p dlg.GetLineNumber
	@m_pTextCtrl.set_insertion_point(@m_pTextCtrl.xy_to_position(0, dlg.GetLineNumber - 1))
    end
    dlg.destroy
  end

  def onMenuOptionBackgroundColor(event)
    colourData = ColourData.new
    colour = @m_pTextCtrl.get_background_colour
    colourData.set_colour(colour)
    colourData.set_choose_full(true)
    dlg = ColourDialog.new(self, colourData)
    if dlg.show_modal == ID_OK
	colourData = dlg.get_colour_data
	@m_pTextCtrl.set_background_colour(colourData.get_colour)
	@m_pTextCtrl.refresh
    end
    dlg.destroy
  end

  def onMenuOptionFont(event)

    fontData = FontData.new
    font = @m_pTextCtrl.get_font
    fontData.set_initial_font(font)
    colour = @m_pTextCtrl.get_foreground_colour
    fontData.set_colour(colour)
    fontData.set_show_help(true)

    dlg = FontDialog.new(self, fontData)
    if dlg.show_modal == ID_OK
	fontData = dlg.get_font_data
	font = fontData.get_chosen_font
	@m_pTextCtrl.set_font(font)
	@m_pTextCtrl.set_foreground_colour(fontData.get_colour)
	@m_pTextCtrl.refresh
    end
    dlg.destroy
  end

  def onMenuOptionDirectory(event)
    dlg = DirDialog.new(self, "Select a Working directory", get_cwd())
    if dlg.show_modal == ID_OK
	set_working_directory(dlg.get_path)
    end
    dlg.destroy
  end

  def onClose(event)

    destroy = true
    if event.can_veto
	if @m_pTextCtrl.is_modified
	  dlg = MessageDialog.new(self, "Text is changed!\nAre you sure you want to exit?",
		"Text changed!!!", YES_NO | NO_DEFAULT)
	  result = dlg.show_modal
	  if result == ID_NO
		event.veto
		destroy = false
	  end
	end
    end
    if destroy
	destroy()
    end
  end
end


class RbApp < App
  def OnInit
    frame = TextFrame.new("Simple Text Editor", 100, 100, 400, 300)
    frame.show(TRUE)
    set_top_window(frame)
  end

end

a = RbApp.new
a.main_loop
