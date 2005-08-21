#   Copyright 2004-2005 by Kevin Smith
#   released under the MIT-style wxruby2 license

%include "../common.i"

%module(directors="1") wxSplitterWindow

%rename(Init) Initialize(wxWindow*  window ) ;

%{
#include <wx/splitter.h>
%}

%import "include/wxObject.h"
%import "include/wxEvtHandler.h"
%import "include/wxWindow.h"

%include "include/wxSplitterWindow.h"
