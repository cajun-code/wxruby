#   Copyright 2004-2005 by Kevin Smith
#   released under the MIT-style wxruby2 license

%feature("director");
%feature("compactdefaultargs");

%runtime %{
// # SWIG 1.3.29 added this new feature which we can't use (yet)
#define SWIG_DIRECTOR_NOUEH TRUE



#  undef GetClassName
#  undef GetClassInfo
#  undef Yield
#  undef GetMessage
#  undef FindWindow
#  undef GetCharWidth
#  undef DrawText
#  undef StartDoc
#  undef CreateDialog
#  undef Sleep
#  undef Connect
#  undef connect

#  define WXINTL_NO_GETTEXT_MACRO 1
#include <wx/wx.h>
#include <wx/dcbuffer.h>


#if ! wxCHECK_VERSION(2,6,3)
#error "wxRuby requires WxWidgets version 2.6.3"
#endif

extern void GcMarkDeleted(void *);
extern bool GcIsDeleted(void *);
extern void GcMapPtrToValue(void *ptr, VALUE val);
extern VALUE GcGetValueFromPtr(void *ptr);
extern void GcFreefunc(void *);

extern VALUE mWxruby2;
%}

%include "typedefs.i"
%include "typemap.i"

#
# Protect certain classes from the GC
#
%define GC_NEVER(kls)
%feature("freefunc") kls "GcFreefunc";
%enddef

#
# This may do something someday
#
%define GC_ALWAYS(klass)
%enddef
