// Copyright 2004-2007 by Kevin Smith
// released under the MIT-like wxRuby license

%include "../common.i"

%module(directors="1") wxBoxSizer
GC_MANAGE_AS_OBJECT(wxBoxSizer);

%import "include/wxObject.h"
%import "include/wxSizer.h"

%include "include/wxBoxSizer.h"
