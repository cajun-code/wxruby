// Copyright 2004-2007, wxRuby development team
// released under the MIT-like wxRuby2 license

%include "../common.i"

%module(directors="1") wxTextAttr;
GC_MANAGE(wxTextAttr);

%{
#include <wx/textctrl.h>
%}

%include "include/wxTextAttr.h"
