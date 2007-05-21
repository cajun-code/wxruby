// Copyright 2004-2007 by Kevin Smith
// released under the MIT-like wxRuby license

%include "../common.i"

%module(directors="1") wxRadioBox
GC_MANAGE_AS_WINDOW(wxRadioBox);
%{
#include <wx/wx.h>
#include <wx/radiobox.h>
%}

%ignore wxRadioBox::wxRadioBox();
%ignore wxRadioBox::Number;   # Obsolete

%ignore wxRadioBox::Show(int item, const bool show = true);


%import "include/wxObject.h"
%import "include/wxEvtHandler.h"
%import "include/wxWindow.h"
%import "include/wxControl.h"

%include "include/wxRadioBox.h"
%extend wxRadioBox {
	bool ShowItem(int item, const bool show = true)
	{
		return self->Show(item, show);
	}
}
