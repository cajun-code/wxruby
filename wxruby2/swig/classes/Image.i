// Copyright 2004-2007 by Kevin Smith
// released under the MIT-like wxRuby license

%include "../common.i"

%module(directors="1") wxImage
GC_MANAGE_AS_OBJECT(wxImage);

%{
#include <wx/image.h>
%}

%typemap(in) unsigned char * data {
	if(TYPE($input) == T_STRING)
		$1 = reinterpret_cast< unsigned char * >(StringValuePtr($input));
	else
		SWIG_exception_fail(SWIG_ERROR, "in method 'set_data', expected argument of type 'string'");
}

%apply unsigned char * OUTPUT { unsigned char * r, unsigned char * g, unsigned char * b }

%ignore wxImage::Create();

// Handler methods are not supported in wxRuby; if these methods are
// added, corrected freearg typemap for input wxString in static method
// will be required
%ignore wxImage::AddHandler;
%ignore wxImage::FindHandler;
%ignore wxImage::FindHandlerMime;
%ignore wxImage::RemoveHandler;

%import "include/wxObject.h"

%include "include/wxImage.h"
