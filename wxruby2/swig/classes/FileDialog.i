#   Copyright 2004 by Kevin Smith
#   released under the wxWidgets license
#   as part of the wxRuby project
%include "../common.i"

%module(directors="1") wxFileDialog

#if 0
%typemap(in,numinputs=0) wxArrayString &(wxArrayString sel)
{
	$1 = &sel;
}

%typemap(argout) wxArrayString &{
  $result = rb_ary_new();
  for (int i = 0; i < $1->GetCount(); i++)
    rb_ary_push($result,rb_str_new2((*$1)[i].c_str()));
}
#endif

%include "include/wxFileDialog.h"
