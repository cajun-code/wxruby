// wxGenericDirCtrl.h
// This file was automatically generated
// by extractxml.rb, part of the wxRuby project
// Do not make changes directly to this file!

#if !defined(_wxGenericDirCtrl_h_)
#define _wxGenericDirCtrl_h_
class wxGenericDirCtrl : public wxControl
{
public:
   wxGenericDirCtrl() ;
   wxGenericDirCtrl(wxWindow*  parent , const wxWindowID  id = -1, const wxString&  dir = wxDirDialogDefaultFolderStr, const wxPoint&  pos = wxDefaultPosition, const wxSize&  size = wxDefaultSize, long  style = wxDIRCTRL_3D_INTERNAL|wxSUNKEN_BORDER, const wxString&  filter = wxEmptyString, int  defaultFilter = 0, const wxString&  name = wxTreeCtrlNameStr) ;
  virtual  ~wxGenericDirCtrl() ;
  bool Create(wxWindow*  parent , const wxWindowID  id = -1, const wxString&  dir = wxDirDialogDefaultFolderStr, const wxPoint&  pos = wxDefaultPosition, const wxSize&  size = wxDefaultSize, long  style = wxDIRCTRL_3D_INTERNAL|wxSUNKEN_BORDER, const wxString&  filter = wxEmptyString, int  defaultFilter = 0, const wxString&  name = wxTreeCtrlNameStr) ;
  void Init() ;
  bool ExpandPath(const wxString&  path ) ;
  wxString GetDefaultPath() const;
  wxString GetPath() const;
  wxString GetFilePath() const;
  wxString GetFilter() const;
  int GetFilterIndex() const;
  wxDirFilterListCtrl* GetFilterListCtrl() const;
  wxTreeItemId GetRootId() ;
  wxTreeCtrl* GetTreeCtrl() const;
  void SetDefaultPath(const wxString&  path ) ;
  void SetFilter(const wxString&  filter ) ;
  void SetFilterIndex(int  n ) ;
  void SetPath(const wxString&  path ) ;
};


#endif