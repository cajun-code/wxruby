// Copyright 2004-2007 by Kevin Smith
// released under the MIT-like wxRuby license

%include "../common.i"

%module(directors="1") wxStdDialogButtonSizer
GC_MANAGE_AS_SIZER(wxStdDialogButtonSizer);


// shared functions 
%include "../shared/sizers.i"

%import "include/wxObject.h"
%import "include/wxSizer.h"
%import "include/wxBoxSizer.h"

%include "include/wxStdDialogButtonSizer.h"
