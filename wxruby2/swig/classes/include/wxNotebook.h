// wxNotebook.h
// This file was automatically generated
// by extractxml.rb, part of the wxRuby project
// Do not make changes directly to this file!

#if !defined(_wxNotebook_h_)
#define _wxNotebook_h_
class wxNotebook : public wxControl
{
public:
   wxNotebook() ;
  wxNotebook(wxWindow*  parent , wxWindowID  id , const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxString&  name = "notebook");
  virtual  ~wxNotebook() ;
  bool AddPage(wxNotebookPage*  page , const wxString&  text , bool select = false, int imageId = -1) ;
  void AdvanceSelection(bool forward = true) ;
  void AssignImageList(wxImageList*  imageList ) ;
  bool Create(wxWindow*  parent , wxWindowID  id , const wxPoint& pos , const wxSize&  size , long style , const wxString&  name = "notebook");
  bool DeleteAllPages() ;
  bool DeletePage(int  page ) ;
  wxImageList* GetImageList() const;
  wxNotebookPage* GetPage(int  page ) ;
  int GetPageCount() const;
  int GetPageImage(int  nPage ) const;
  wxString GetPageText(int  nPage ) const;
  int GetRowCount() const;
  int GetSelection() const;
  bool InsertPage(int  index , wxNotebookPage*  page , const wxString&  text , bool select = false, int imageId = -1) ;
  virtual void OnSelChange(wxNotebookEvent&  event ) ;
  bool RemovePage(int  page ) ;
  void SetImageList(wxImageList*  imageList ) ;
  void SetPadding(const wxSize&  padding ) ;
  void SetPageSize(const wxSize&  size ) ;
  bool SetPageImage(int  page , int  image ) ;
  bool SetPageText(int  page , const wxString&  text ) ;
  int SetSelection(int  page ) ;
};


#endif
