/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 1.3.25
 * 
 * This file is not intended to be easily readable and contains a number of 
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG 
 * interface file instead. 
 * ----------------------------------------------------------------------------- */

#ifndef SWIG_WxMenuItem_WRAP_H_
#define SWIG_WxMenuItem_WRAP_H_

class Swig::Director;


class SwigDirector_wxMenuItem : public wxMenuItem, public Swig::Director {

public:
    SwigDirector_wxMenuItem(VALUE self, wxMenu *parentMenu = (wxMenu *) NULL, int id = wxID_SEPARATOR, wxString const &name = wxEmptyString, wxString const &help = wxEmptyString, wxItemKind kind = wxITEM_NORMAL, wxMenu *subMenu = (wxMenu *) NULL);
    virtual ~SwigDirector_wxMenuItem();
    virtual void SetCheckable(bool checkable);
};


#endif
