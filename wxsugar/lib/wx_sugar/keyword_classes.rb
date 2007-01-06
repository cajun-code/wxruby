# = WxSugar - Keyword Constructors Classes
# 
# This extension defines the keyword parameters for +new+ methods for
# widgets, windows and frames. It's for use with *Keyword Constructors*
# and is no use on its own - except if you are looking for a bug or want
# to add a  missing class.

module WxSugar
  @defined_classes = {}

  # accepts a string unadorned name of a WxWidgets class, and block, which 
  # defines the constructor parameters and style flags for that class.
  # If the named class exists in the available WxRuby, the block is run and 
  # the class may use keyword constructors. If the class is not available, the
  # block is ignored.
  def self.define_keyword_ctors(klass_name, &block)
    # check this class hasn't already been defined
    if @defined_classes[klass_name]
      raise ArgumentError, "Keyword ctor for #{klass_name} already defined"
    else
      @defined_classes[klass_name] = true
    end

    begin     
      klass =  Wx::const_get(klass_name)
    rescue NameError
      return nil
    end
    klass.module_eval { include WxSugar::KeywordConstructor }
    # automatically add :id as the first argument, unless this is a
    # Dialog subclass - which don't require this argument
    unless klass < Wx::Dialog
      klass.wx_ctor_params :id
    end
    klass.instance_eval(&block)
  end
end

# Window : base class for all widgets and frames
WxSugar.define_keyword_ctors('Window') do
   wx_ctor_params :pos, :size, :style
   wx_ctor_params :name => 'window'
end


### FRAMES

# wxTopLevelWindow 	ABSTRACT: Any top level window, dialog or frame

# Normal frame
WxSugar.define_keyword_ctors('Frame') do
  wx_ctor_params :title => ''
  wx_ctor_params :pos, :size, :style => Wx::DEFAULT_FRAME_STYLE
  wx_ctor_params :name => 'frame'
end

# MDI child frame
WxSugar.define_keyword_ctors('MDIChildFrame') do
  wx_ctor_params :title => ''
  wx_ctor_params :pos, :size, :style => Wx::DEFAULT_FRAME_STYLE
  wx_ctor_params :name => 'frame'
end

# MDI parent frame
WxSugar.define_keyword_ctors('MDIParentFrame') do
  wx_ctor_params :title => ''
  wx_ctor_params :pos, :size
  wx_ctor_params :style => Wx::DEFAULT_FRAME_STYLE|Wx::VSCROLL|Wx::HSCROLL
  wx_ctor_params :name => 'frame'
end

# wxMiniFrame 	A frame with a small title bar
WxSugar.define_keyword_ctors('MiniFrame') do
  wx_ctor_params :title => ''
  wx_ctor_params :pos, :size
  wx_ctor_params :style =>  Wx::DEFAULT_FRAME_STYLE
  wx_ctor_params :name => 'frame'
end

# wxSplashScreen 	Splash screen class
# FIXME - this probably won't work at present because the 'parent' arg
# comes in a funny place in this class's ctor
# 
# WxSugar.define_keyword_ctors('SplashScreen') do
#   wx_ctor_params :bitmap => Wx::NULL_BITMAP
#   wx_ctor_params :splashstyle, :milliseconds, :id => 1
#   wx_ctor_params :parent => nil
#   wx_ctor_params :title => ''
#   wx_ctor_params :pos, :size
#   wx_ctor_params :style => Wx::SIMPLE_BORDER|Wx::FRAME_NO_TASKBAR|Wx::STAY_ON_TOP
# end

# wxPropertySheetDialog 	Property sheet dialog
# wxTipWindow 	Shows text in a small window

# wxWizard 	A wizard dialog
WxSugar.define_keyword_ctors('Wizard') do
  wx_ctor_params :title => ''
  wx_ctor_params :bitmap => Wx::NULL_BITMAP
  wx_ctor_params :pos, :size
  wx_ctor_params :style => Wx::DEFAULT_DIALOG_STYLE
end


# MISCELLANEOUS WINDOWS

# A window whose colour changes according to current user settings
WxSugar.define_keyword_ctors('Panel') do
  wx_ctor_params :pos, :size, :style => Wx::TAB_TRAVERSAL
  wx_ctor_params :name => 'panel'
end

# wxScrolledWindow 	Window with automatically managed scrollbars
WxSugar.define_keyword_ctors('ScrolledWindow') do
  wx_ctor_params :pos, :size, :style => Wx::VSCROLL|Wx::HSCROLL
  wx_ctor_params :name => 'scrolledWindow'
  wx_ctor_flags  :h_scroll => Wx::HSCROLL, 
                 :v_scroll => Wx::VSCROLL
end

# wxGrid 	A grid (table) window
WxSugar.define_keyword_ctors('Grid') do
  wx_ctor_params :pos, :size, :style => Wx::WANTS_CHARS
  wx_ctor_params :name => 'grid'
end

# Window which can be split vertically or horizontally
WxSugar.define_keyword_ctors('SplitterWindow') do
  wx_ctor_params :pos, :size, :style => Wx::SP_3D
  wx_ctor_params :name => 'splitterWindow'
end

# Implements the status bar on a frame
WxSugar.define_keyword_ctors('StatusBar') do
  wx_ctor_params :style => Wx::ST_SIZEGRIP
  wx_ctor_params :name => 'statusBar'
end

# Toolbar class
WxSugar.define_keyword_ctors('ToolBar') do
  wx_ctor_params :pos, :size, :style => Wx::TB_HORIZONTAL|Wx::NO_BORDER
  wx_ctor_params :name => 'toolBar' # not as documented in Wx 2.6.3
end

# Notebook class
WxSugar.define_keyword_ctors('Notebook') do
  wx_ctor_params :pos, :size, :style, :name => 'noteBook' 
end

# Similar to notebook but using list control - undocumented
WxSugar.define_keyword_ctors('Listbook') do
  wx_ctor_params :pos, :size, :style, :name => 'listBook'
end

# Similar to notebook but using choice control
WxSugar.define_keyword_ctors('Choicebook') do
  wx_ctor_params :pos, :size, :style, :name => 'choiceBook'
end

# wxSashWindow:	Window with four optional sashes that can be dragged
WxSugar.define_keyword_ctors('SashWindow') do
  wx_ctor_params :pos, :size
  wx_ctor_params :style =>  Wx::CLIP_CHILDREN|Wx::SW_3D
  wx_ctor_params :name => 'sashWindow'
end

# wxSashLayoutWindow: Window that can be involved in an IDE-like layout
# arrangement
WxSugar.define_keyword_ctors('SashLayoutWindow') do
  wx_ctor_params :pos, :size
  wx_ctor_params :style =>  Wx::CLIP_CHILDREN|Wx::SW_3D
  wx_ctor_params :name => 'layoutWindow'
end

# wxVScrolledWindow: As wxScrolledWindow but supports lines of variable height

# wxWizardPage: A base class for the page in wizard dialog.
WxSugar.define_keyword_ctors('WizardPage') do
  wx_ctor_params :bitmap => Wx::NULL_BITMAP
end

# wxWizardPageSimple: A page in wizard dialog.
WxSugar.define_keyword_ctors('WizardPageSimple') do
  wx_ctor_params :prev,  :next, :bitmap => Wx::NULL_BITMAP
end

### DIALOGS
# wxDialog 	Base class for common dialogs
WxSugar.define_keyword_ctors('Dialog') do
  wx_ctor_params :title => ''
  wx_ctor_params :pos, :size, :style => Wx::DEFAULT_DIALOG_STYLE
  wx_ctor_params :name => 'dialogBox'
end

# wxColourDialog 	Colour chooser dialog
WxSugar.define_keyword_ctors('ColourDialog') do
  wx_ctor_params :colour_data => nil
end

# wxDirDialog 	Directory selector dialog
WxSugar.define_keyword_ctors('DirDialog') do
  wx_ctor_params :message => 'Choose a directory'
  wx_ctor_params :default_path => ''
  wx_ctor_params :style, :pos, :size, :name => 'wxDirCtrl'
end

# wxFileDialog 	File selector dialog
WxSugar.define_keyword_ctors('FileDialog') do
  wx_ctor_params :message => 'Choose a file'
  wx_ctor_params :default_dir  => ''
  wx_ctor_params :default_file => ''
  wx_ctor_params :wildcard => '*.*'
  wx_ctor_params :style, :pos
end

# wxFindReplaceDialog 	Text search/replace dialog
WxSugar.define_keyword_ctors('FindReplaceDialog') do
  wx_ctor_params :find_replace_data => Wx::FindReplaceData.new()
  wx_ctor_params :title => 'findReplaceDialog'
  wx_ctor_params :style
end

# wxMultiChoiceDialog 	Dialog to get one or more selections from a list
# wxSingleChoiceDialog 	Dialog to get a single selection from a list and return the string

# Dialog to get a single line of text from the user
WxSugar.define_keyword_ctors('TextEntryDialog') do
  wx_ctor_params :message => ''
  wx_ctor_params :caption => 'Please enter text'
  wx_ctor_params :default_value => ''
  wx_ctor_params :style => Wx::OK|Wx::CANCEL|Wx::CENTRE
  wx_ctor_params :pos
end

# wxPasswordEntryDialog 	Dialog to get a password from the user
# WxSugar.define_keyword_ctors('PasswordEntryDialog') do
#   wx_ctor_params :message => ''
#   wx_ctor_params :caption => 'Enter password'
#   wx_ctor_params :default_value => ''
#   wx_ctor_params :style => Wx::OK|Wx::CANCEL|Wx::CENTRE
#   wx_ctor_params :pos
# end

# wxFontDialog 	Font chooser dialog
# wxPageSetupDialog 	Standard page setup dialog
WxSugar.define_keyword_ctors('PageSetupDialog') do
  wx_ctor_params :data
end

# wxPrintDialog 	Standard print dialog
WxSugar.define_keyword_ctors('PrintDialog') do
  wx_ctor_params :data
end


# Simple message box dialog
WxSugar.define_keyword_ctors('MessageDialog') do
  wx_ctor_params :message => ''
  wx_ctor_params :caption => 'Message box'
  wx_ctor_params :style => Wx::OK|Wx::CANCEL
  wx_ctor_params :pos
end

### CONTROLS

# Push button control, displaying text
WxSugar.define_keyword_ctors('Button') do
  wx_ctor_params :label => ''
  wx_ctor_params :pos, :size, :style
  wx_ctor_params :validator, :name => 'button'
end

# Push button control, displaying a bitmap
WxSugar.define_keyword_ctors('BitmapButton') do
  wx_ctor_params :bitmap, :pos, :size, :style => Wx::BU_AUTODRAW
  wx_ctor_params :validator, :name => 'button'
end

# A button which stays pressed when clicked by user.
WxSugar.define_keyword_ctors('ToggleButton') do
  wx_ctor_params :label, :pos, :size, :style
  wx_ctor_params :validator, :name => 'checkBox'
end

# Control showing an entire calendar month
WxSugar.define_keyword_ctors('CalendarCtrl') do
  wx_ctor_params :date => Time.now()
  wx_ctor_params :pos, :size, :style => Wx::CAL_SHOW_HOLIDAYS
  wx_ctor_params :name => 'calendar'
end

# 	Checkbox control
WxSugar.define_keyword_ctors('CheckBox') do
  wx_ctor_params :label => ''
  wx_ctor_params :pos, :size, :style
  wx_ctor_params :validator, :name => 'checkBox'
end

# A listbox with a checkbox to the left of each item
WxSugar.define_keyword_ctors('CheckListBox') do 	
  wx_ctor_params :pos, :size, :choices, :style
  wx_ctor_params :validator, :name => 'listBox'
end

# wxChoice 	Choice control (a combobox without the editable area)
WxSugar.define_keyword_ctors('Choice') do
  wx_ctor_params :pos, :size, :choices, :style
  wx_ctor_params :validator, :name => 'choice'
end

# wxComboBox 	A choice with an editable area
WxSugar.define_keyword_ctors('ComboBox') do
  wx_ctor_params :value => ''
  wx_ctor_params :pos, :size, :choices => []
  wx_ctor_params :style 
  wx_ctor_params :validator, :name => 'comboBox'
end

# wxDatePickerCtrl 	Small date picker control

# wxGauge 	A control to represent a varying quantity, such as time
# remaining
WxSugar.define_keyword_ctors('Gauge') do
  wx_ctor_params :range, :pos, :size, :style => Wx::GA_HORIZONTAL
  wx_ctor_params :validator, :name
end

# wxGenericDirCtrl 	A control for displaying a directory tree
WxSugar.define_keyword_ctors('GenericDirCtrl') do
  # TODO :dir => Wx::DIR_DIALOG_DEFAULT_FOLDER_STR
  wx_ctor_params :dir => '' 
  wx_ctor_params :pos, :size, 
                 :style => Wx::DIRCTRL_3D_INTERNAL|Wx::SUNKEN_BORDER
  wx_ctor_params :filter => ''
  wx_ctor_params :default_filter => 0
  wx_ctor_params :name => 'genericDirCtrl'
end


# wxHtmlListBox 	A listbox showing HTML content
# wxListBox 	A list of strings for single or multiple selection
WxSugar.define_keyword_ctors('ListBox') do
  wx_ctor_params :pos, :size, :choices => []
  wx_ctor_params :style
  wx_ctor_params :validator, :name => 'listBox'
end

# wxListCtrl 	A control for displaying lists of strings and/or icons, plus a multicolumn report view
WxSugar.define_keyword_ctors('ListCtrl') do
  wx_ctor_params :pos, :size, :style => Wx::LC_ICON
  wx_ctor_params :validator, :name => 'listCtrl'
end

# wxListView 	A simpler interface (facade for wxListCtrl in report mode

# wxTreeCtrl 	Tree (hierarchy) control
WxSugar.define_keyword_ctors('TreeCtrl') do
  wx_ctor_params :pos, :size, :style => Wx::TR_HAS_BUTTONS
  wx_ctor_params :validator, :name => 'treeCtrl'
end

# wxSpinCtrl 	A spin control - i.e. spin button and text control
WxSugar.define_keyword_ctors('SpinCtrl') do
  wx_ctor_params :value => ''
  wx_ctor_params :pos, :size, :style => Wx::SP_ARROW_KEYS
  wx_ctor_params :min => 0
  wx_ctor_params :max => 100
  wx_ctor_params :initial => 0
  wx_ctor_params :name => 'spinCtrl'
end

# One or more lines of non-editable text
WxSugar.define_keyword_ctors('StaticText') do
  wx_ctor_params :label, :pos, :size, :style, :name => 'staticText'
end

WxSugar.define_keyword_ctors('StaticBox') do
  wx_ctor_params :label, :pos, :size, :style, :name => 'staticBox'
end

WxSugar.define_keyword_ctors('StaticLine') do
  wx_ctor_params :pos, :size, :style => Wx::LI_HORIZONTAL
  wx_ctor_params :name => 'staticBox'
end

# wxStaticBitmap 	A control to display a bitmap
WxSugar.define_keyword_ctors('StaticBitmap') do
  wx_ctor_params :label, :pos, :size, :style
end


# wxRadioBox 	A group of radio buttons
WxSugar.define_keyword_ctors('RadioBox') do
  wx_ctor_params :label => ''
  wx_ctor_params :pos, :size, :choices => []
  wx_ctor_params :major_dimension => 0
  wx_ctor_params :style => Wx::RA_SPECIFY_COLS
  wx_ctor_params :validator, :name => 'radioBox'
end

# wxRadioButton: A round button used with others in a mutually exclusive way
WxSugar.define_keyword_ctors('RadioButton') do
  wx_ctor_params :label => ''
  wx_ctor_params :pos, :size, :style => 0
  wx_ctor_params :validator, :name => 'radioButton'
end

# wxSlider 	A slider that can be dragged by the user
WxSugar.define_keyword_ctors('Slider') do
  wx_ctor_params :value => 0
  wx_ctor_params :min_value, :max_value
  wx_ctor_params :pos, :size, :style => Wx::SL_HORIZONTAL
  wx_ctor_params :validator, :name => 'slider'
end

# wxSpinButton - Has two small up and down (or left and right) arrow buttons
WxSugar.define_keyword_ctors('SpinButton') do
   wx_ctor_params :pos, :size, :style => Wx::SP_HORIZONTAL
   wx_ctor_params :name => 'spinButton'
end

# wxVListBox 	A listbox supporting variable height rows

# wxTextCtrl 	Single or multiline text editing control
WxSugar.define_keyword_ctors('TextCtrl') do
  wx_ctor_params :value => ''
  wx_ctor_params :pos, :size, :style
  wx_ctor_params :validator, :name => 'textCtrl'
end

# wxHtmlWindow - Control for displaying HTML
WxSugar.define_keyword_ctors('HtmlWindow') do
  wx_ctor_params :pos, :size, :style => Wx::HW_DEFAULT_STYLE
  wx_ctor_params :name => 'htmlWindow'
end
