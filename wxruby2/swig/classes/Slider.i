// Copyright 2004-2007 by Kevin Smith
// released under the MIT-like wxRuby license

%include "../common.i"

%module(directors="1") wxSlider
GC_MANAGE_AS_WINDOW(wxSlider);
%{
#include <wx/wx.h>
#include <wx/slider.h>
%}

%ignore wxSlider::wxSlider();

%import "include/wxObject.h"
%import "include/wxEvtHandler.h"
%import "include/wxWindow.h"
%import "include/wxControl.h"

%include "include/wxSlider.h"
