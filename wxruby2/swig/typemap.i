// Copyright 2004-2007 by Kevin Smith
// released under the MIT-style wxruby2 license

##############################################################
%typemap(in) wxString& {
	// $argnum: $1_type $1_name ($1_mangle) [$1_ltype]
	$1 = new wxString(StringValuePtr($input), wxConvUTF8);
}

%typemap(in) const wxString& {
	$1 = new wxString(StringValuePtr($input), wxConvUTF8);
}

%typemap(in) wxString* {
	$1 = new wxString(StringValuePtr($input), wxConvUTF8);
}

%typemap(directorout) wxString, wxString& "$result = wxString(StringValuePtr($input), wxConvUTF8);";

%include "typemaps.i"

%typemap(directorargout) ( int * OUTPUT ) {
  if($1 != NULL)
  {
    if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 1))
    {
      *$1 = (int)NUM2INT(rb_ary_entry(result,0));
      rb_ary_shift(result);
    }
    else
    {
      *$1 = 0;
    }
  }
  else
  {
    if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 1))
      rb_ary_shift(result);  // Guess we should shift it anyhow!
  }
}

%typemap(directorargout) ( long * OUTPUT ) {
  if($1 != NULL)
  {
    if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 1))
    {
      *$1 = (long)NUM2LONG(rb_ary_entry(result,0));
      rb_ary_shift(result);
    }
    else
    {
      *$1 = 0;
    }
  }
  else
  {
    if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 1))
      rb_ary_shift(result);  // Guess we should shift it anyhow!
  }
}

/*
Currently incompatible with the ruby post-processing of swigged .cpp files
Needs to be fixed in fixdeleting.rb before this can be uncommented out
%typemap(freearg) wxString & {
	delete $1;
}

%typemap(freearg) const wxString& {
	delete $1;
}

 Removed temporarily 2006-04-16 kbs
%typemap(freearg) wxString* {
	delete $1;
}
*/

%typemap(directorin) wxString, const wxString &, wxString & "$input = rb_str_new2((const char *)$1.mb_str());";

%typemap(directorin) wxString *, const wxString * "TODO: $1_name->mb_str()";
                                                                                                   
%typemap(out) wxString {
	$result = rb_str_new2((const char *)$1.mb_str(wxConvUTF8));
}

%typemap(out) wxString& {
	$result = rb_str_new2((const char *)(*$1).mb_str(wxConvUTF8));
}

%typemap(out) const wxString& {
	$result = rb_str_new2((const char *)(*$1).mb_str(wxConvUTF8));
}

%apply wxString& { wxString* }
                                                                               
%typemap(varout) wxString {
	$result = rb_str_new2((const char *)$1.mb_str(wxConvUTF8));
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) wxString {
	$1 = (TYPE($input) == T_STRING);
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) wxString & {
	$1 = (TYPE($input) == T_STRING);
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) wxString const & {
	$1 = (TYPE($input) == T_STRING);
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) wxString *{
	$1 = (TYPE($input) == T_STRING);
}

##############################################################
%typemap(in) const wxChar const * {
	$1 = new wxString(StringValuePtr($input), wxConvUTF8).c_str();
}

%typemap(out) wxChar const * {
	$result = rb_str_new2((const char *)wxString(*$1).mb_str(wxConvUTF8));
}

%typemap(directorin) wxChar const * "$input = rb_str_new2((const char *)wxString($1).mb_str());";

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING) wxChar const *{
	$1 = (TYPE($input) == T_STRING);
}

%typemap(varout) wxChar const * {
	$result = rb_str_new2((const char *)wxString($1).mb_str(wxConvUTF8));
}


##############################################################

%typemap(in) void* {
	$1 = (void*)($input);
}

%typemap(out) void* {
    $result = (VALUE)($1);
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) void * {
	$1 = TRUE;
}

##############################################################

##############################################################
%typemap(in) wxItemKind {
	$1 = (wxItemKind)NUM2INT($input);
}

%typemap(out) wxItemKind {
    $result = INT2NUM((int)$1);
}

# fixes mixup between 
# wxMenuItem* wxMenu::Append(int itemid, const wxString& text, const wxString& help = wxEmptyString, wxItemKind kind = wxITEM_NORMAL)
# and
# void wxMenu::Append(int itemid, const wxString& text, const wxString& help, bool isCheckable);
%typemap(typecheck, precedence=SWIG_TYPECHECK_INTEGER) wxItemKind {
	$1 = (TYPE($input) == T_FIXNUM && TYPE($input) != T_TRUE && TYPE($input) != T_FALSE);
}

%typemap(in,numinputs=1) (int n, const wxString choices []) (wxString *arr)
{
  if (($input == Qnil) || (TYPE($input) != T_ARRAY))
  {
    $1 = 0;
    $2 = NULL;
  }
  else
  {
    arr = new wxString[RARRAY($input)->len];
    for (int i = 0; i < RARRAY($input)->len; i++)
    {
	  VALUE str = rb_ary_entry($input,i);
	  arr[i] = wxString(StringValuePtr(str), wxConvUTF8);
    }
    $1 = RARRAY($input)->len;
    $2 = arr;
  }
}

%typemap(default,numinputs=1) (int n, const wxString choices[]) 
{
    $1 = 0;
    $2 = NULL;
}

%typemap(freearg) (int n , const wxString choices[])
{
    if ($2 != NULL) delete [] $2;
}

%typemap(typecheck) (int n , const wxString choices[])
{
   $1 = (TYPE($input) == T_ARRAY);
}

%apply (int n, const wxString choices []) { (int n, const wxString* choices),(int nItems, const wxString *items) }

##############################################################

%typemap(in,numinputs=1) (int n, wxPoint points[]) (wxPoint *arr)
{
  if (($input == Qnil) || (TYPE($input) != T_ARRAY))
  {
    $1 = 0;
    $2 = NULL;
  }
  else
  {
    wxPoint *ptmp;
    arr = new wxPoint[RARRAY($input)->len];
    for (int i = 0; i < RARRAY($input)->len; i++)
    {
	SWIG_ConvertPtr(rb_ary_entry($input,i), (void **) &ptmp, SWIGTYPE_p_wxPoint, 1);
	if (ptmp == NULL)
		rb_raise(rb_eTypeError, "null reference");
        arr[i] = *ptmp;
    }
    $1 = RARRAY($input)->len;
    $2 = arr;
  }
}

%typemap(default,numinputs=1) (int n, wxPoint points[]) 
{
    $1 = 0;
    $2 = NULL;
}

%typemap(freearg) (int n , wxPoint points [])
{
    if ($2 != NULL) delete [] $2;
}

%typemap(typecheck) (int n , wxPoint points[])
{
   $1 = (TYPE($input) == T_ARRAY);
}

%apply (int n, wxPoint points []) { (int n, wxPoint* points),(int nItems, wxPoint *points) }

##############################################################

%typemap(in) wxArrayString & (wxArrayString tmp){
 
  if (($input == Qnil) || (TYPE($input) != T_ARRAY))
  {
    $1 = &tmp;
  }
  else
  {
    
    for (int i = 0; i < RARRAY($input)->len; i++)
    {
	  VALUE str = rb_ary_entry($input, i);
	  wxString item(StringValuePtr(str), wxConvUTF8);
	  tmp.Add(item);
    }
    
    $1 = &tmp;
  }

}

%typemap(out) wxArrayString & {

  $result = rb_ary_new();

  for (int i = 0; i < $1->GetCount(); i++)
  {
    rb_ary_push($result,rb_str_new2((const char *)(*$1)[i].mb_str()));
  }
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_STRING_ARRAY) wxArrayString &
{
   $1 = (TYPE($input) == T_ARRAY);
}

%apply wxArrayString & { const wxArrayString &}

##############################################################

%typemap(in) wxArrayInt (wxArrayInt tmp){
 
  if (($input == Qnil) || (TYPE($input) != T_ARRAY))
  {
    $1 = &tmp;
  }
  else
  {
    
    for (int i = 0; i < RARRAY($input).len; i++)
    {
      int item = NUM2INT(rb_ary_entry($input,i));
      tmp.Add(item);
    }
    
    $1 = &tmp;
  }

}

%typemap(out) wxArrayInt {

  $result = rb_ary_new();

  for (int i = 0; i < $1.GetCount(); i++)
  {
    rb_ary_push($result,INT2NUM( $1.Item(i) ) );
  }
}

%typemap(typecheck) wxArrayInt
{
   $1 = (TYPE($input) == T_ARRAY);
}

##############################################################

%typemap(in) wxEdge {
	$1 = (wxEdge)NUM2INT($input);
}

%typemap(out) wxEdge {
    $result = INT2NUM((int)$1);
}

%typemap(typecheck) wxEdge {
	$1 = TYPE($input) == T_FIXNUM;
}

%typemap(in) wxRelationship {
	$1 = (wxRelationship)NUM2INT($input);
}

%typemap(out) wxRelationship {
    $result = INT2NUM((int)$1);
}

%typemap(typecheck) wxRelationship {
	$1 = TYPE($input) == T_FIXNUM;
}

%typemap(in) wxKeyCode {
	$1 = (wxKeyCode)NUM2INT($input);
}

%typemap(typecheck) wxKeyCode {
	$1 = TYPE($input) == T_FIXNUM;
}

##############################################################

// DC/Window#get_text_extent etc
%apply int *OUTPUT { int * x , int * y , int * descent, int * externalLeading };
%apply wxCoord *OUTPUT { wxCoord * width , wxCoord * height , wxCoord * heightLine };
%apply wxCoord *OUTPUT { wxCoord * w , wxCoord * h , wxCoord * descent, wxCoord * externalLeading };

%typemap(directorargout) ( int * x , int * y , int * descent, int * externalLeading ) {
  if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 2))
  {
    *$1 = ($*1_ltype)NUM2INT(rb_ary_entry(result,0));
    *$2 = ($*2_ltype)NUM2INT(rb_ary_entry(result,1));
    if(($3 != NULL) && RARRAY(result)->len >= 3)
      *$3 = ($*3_ltype)NUM2INT(rb_ary_entry(result,2));
    if(($4 != NULL) && RARRAY(result)->len >= 4)
      *$4 = ($*4_ltype)NUM2INT(rb_ary_entry(result,3));
  }
}

%typemap(directorargout) ( wxCoord * width , wxCoord * height , wxCoord * heightLine ) {
  if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 2))
  {
    *$1 = ($*1_ltype)NUM2INT(rb_ary_entry(result,0));
    *$2 = ($*2_ltype)NUM2INT(rb_ary_entry(result,1));
    if(($3 != NULL) && RARRAY(result)->len >= 3)
      *$3 = ($*3_ltype)NUM2INT(rb_ary_entry(result,2));
  }
}
%typemap(directorargout) ( wxCoord * w , wxCoord * h , wxCoord * descent, wxCoord * externalLeading ) {
  if((TYPE(result) == T_ARRAY) && (RARRAY(result)->len >= 2))
  {
    *$1 = ($*1_ltype)NUM2INT(rb_ary_entry(result,0));
    *$2 = ($*2_ltype)NUM2INT(rb_ary_entry(result,1));
    if(($3 != NULL) && RARRAY(result)->len >= 3)
      *$3 = ($*3_ltype)NUM2INT(rb_ary_entry(result,2));
    if(($4 != NULL) && RARRAY(result)->len >= 4)
      *$4 = ($*4_ltype)NUM2INT(rb_ary_entry(result,3));
  }
}

##############################################################

%typemap(in) wxSystemColour {
	$1 = (wxSystemColour)NUM2INT($input);
}

%typemap(out) wxSystemColour {
    $result = INT2NUM((int)$1);
}

%typemap(in) wxSystemFont {
	$1 = (wxSystemFont)NUM2INT($input);
}

%typemap(out) wxSystemFont {
    $result = INT2NUM((int)$1);
}

%typemap(in) wxSystemMetric {
	$1 = (wxSystemMetric)NUM2INT($input);
}

%typemap(out) wxSystemMetric {
    $result = INT2NUM((int)$1);
}

%apply int *OUTPUT { int * x , int * y , int * w, int * h };
