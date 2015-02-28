" Vim syntax file
" Language:	Visual Basic
" Maintainer:	Robert M. Cortopassi <cortopar@mindspring.com>
" Last Change:	2001 May 09

" This was thrown together after seeing numerous requests on the
" VIM and VIM-DEV mailing lists.  It is by no means complete.
" Send comments, suggestions and requests to the maintainer.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" VB is case insensitive
syn case ignore

syn keyword vbStatement AppActivate Base Beep Call Case ChDir ChDrive Const
syn keyword vbStatement Declare DefBool DefByte DefCur DefDate DefDbl DefDec
syn keyword vbStatement DefInt DefLng DefObj DefSng DefStr Deftype DefVar
syn keyword vbStatement DeleteSetting Dim Do Else End Enum Erase Event Exit
syn keyword vbStatement Explicit FileCopy For ForEach Function Get GoSub GoTo
syn keyword vbStatement If Implements Kill Let LineInput Lock LSet MkDir Name Next
syn keyword vbStatement OnError On Option Private Property Public Put RaiseEvent
syn keyword vbStatement Randomize ReDim Rem Reset Resume Return RmDir RSet
syn keyword vbStatement SavePicture SaveSetting SendKeys SetAttr Static Sub Then
syn keyword vbStatement Type Unlock Wend While Width With Write

syn keyword vbFunction Abs Array Asc AscB AscW Atn Avg
syn keyword vbFunction CBool CByte CCur CDate CDbl Cdec Choose Chr ChrB ChrW
syn keyword vbFunction CInt CLng Command Cos Count CreateObject CSng CStr
syn keyword vbFunction CurDir CVar CVDate CVErr Date DateAdd DateDiff DatePart
syn keyword vbFunction DateSerial DateValue Day DDB Dir DoEvents Environ EOF
syn keyword vbFunction Error Exp FileAttr FileDateTime FileLen Fix Format
syn keyword vbFunction FreeFile FV GetAllStrings GetAttr GetAutoServerSettings
syn keyword vbFunction GetObject GetSetting Hex Hour IIf IMEStatus Input InputB
syn keyword vbFunction InputBox InStr InstB Int IPmt IsArray IsDate IsEmpty
syn keyword vbFunction IsError IsMissing IsNull IsNumeric IsObject LBound LCase
syn keyword vbFunction Left LeftB Len LenB LoadPicture Loc LOF Log LTrim Max
syn keyword vbFunction Mid MidB Min Minute MIRR Month MsgBox Now NPer NPV Oct
syn keyword vbFunction Partition Pmt PPmt PV QBColor Rate RGB Right RightB Rnd
syn keyword vbFunction RTrim Second Seek Sgn Shell Sin SLN Space Spc Sqr StDev
syn keyword vbFunction StDevP Str StrComp StrConv String Switch Sum SYD Tab Tan
syn keyword vbFunction Time Timer TimeSerial TimeValue Trim TypeName UBound UCase
syn keyword vbFunction Val Var VarP VarType Weekday Year

syn keyword vbMethods Accept Activate Add AddCustom AddFile AddFromFile
syn keyword vbMethods AddFromTemplate AddItem AddNew AddToAddInToolbar
syn keyword vbMethods AddToolboxProgID Append AppendChunk Arrange Assert
syn keyword vbMethods AsyncRead BatchUpdate BeginTrans Bind Cancel CancelAsyncRead
syn keyword vbMethods CancelBatch CancelUpdate CanPropertyChange CaptureImage
syn keyword vbMethods CellText CellValue Circle Clear ClearFields ClearSel
syn keyword vbMethods ClearSelCols Clone Close Cls ColContaining ColumnSize
syn keyword vbMethods CommitTrans CompactDatabase Compose Connect Copy
syn keyword vbMethods CopyQueryDef CreateDatabase CreateDragImage CreateEmbed
syn keyword vbMethods CreateField CreateGroup CreateIndex CreateLink
syn keyword vbMethods CreatePreparedStatement CreatePropery CreateQuery
syn keyword vbMethods CreateQueryDef CreateRelation CreateTableDef CreateUser
syn keyword vbMethods CreateWorkspace Customize Delete DeleteColumnLabels
syn keyword vbMethods DeleteColumns DeleteRowLabels DeleteRows DoVerb Drag Draw
syn keyword vbMethods Edit EditCopy EditPaste EndDoc EnsureVisible
syn keyword vbMethods EstablishConnection Execute ExtractIcon Fetch FetchVerbs
syn keyword vbMethods Files FillCache Find FindFirst FindItem FindLast FindNext
syn keyword vbMethods FindPrevious Forward GetBookmark GetChunk GetClipString
syn keyword vbMethods GetData GetFirstVisible GetFormat GetHeader GetLineFromChar
syn keyword vbMethods GetNumTicks GetRows GetSelectedPart GetText GetVisibleCount
syn keyword vbMethods GoBack GoForward Hide HitTest HoldFields Idle
syn keyword vbMethods InitializeLabels InsertColumnLabels InsertColumns
syn keyword vbMethods InsertObjDlg InsertRowLabels InsertRows Item KillDoc
syn keyword vbMethods Layout Line LinkExecute LinkPoke LinkRequest LinkSend Listen
syn keyword vbMethods LoadFile LoadResData LoadResPicture LoadResString LogEvent
syn keyword vbMethods MakeCompileFile MakeReplica MoreResults Move MoveData
syn keyword vbMethods MoveFirst MoveLast MoveNext MovePrevious NavigateTo NewPage
syn keyword vbMethods NewPassword NextRecordset OLEDrag OnAddinsUpdate
syn keyword vbMethods OnConnection OnDisconnection OnStartupComplete Open
syn keyword vbMethods OpenConnection OpenDatabase OpenQueryDef OpenRecordset
syn keyword vbMethods OpenResultset OpenURL Overlay PaintPicture Paste
syn keyword vbMethods PastSpecialDlg PeekData Play Point PopulatePartial PopupMenu
syn keyword vbMethods Print PrintForm PropertyChanged PSet Quit Raise
syn keyword vbMethods RandomDataFill RandomFillColumns RandomFillRows
syn keyword vbMethods rdoCreateEnvironment rdoRegisterDataSource ReadFromFile
syn keyword vbMethods ReadProperty Rebind ReFill Refresh RefreshLink
syn keyword vbMethods RegisterDatabase Reload Remove RemoveAddInFromToolbar
syn keyword vbMethods RemoveItem Render RepairDatabase Reply ReplyAll Requery
syn keyword vbMethods ResetCustom ResetCustomLabel ResolveName RestoreToolbar
syn keyword vbMethods Resync Rollback RollbackTrans RowBookmark RowContaining
syn keyword vbMethods RowTop Save SaveAs SaveFile SaveToFile SaveToolbar
syn keyword vbMethods SaveToOle1File Scale ScaleX ScaleY Scroll Select SelectAll
syn keyword vbMethods SelectPart SelPrint Send SendData Set SetAutoServerSettings
syn keyword vbMethods SetData SetFocus SetOption SetSize SetText SetViewport Show
syn keyword vbMethods ShowColor ShowFont ShowHelp ShowOpen ShowPrinter ShowSave
syn keyword vbMethods ShowWhatsThis SignOff SignOn Size Span SplitContaining
syn keyword vbMethods StartLabelEdit StartLogging Stop Synchronize TextHeight
syn keyword vbMethods TextWidth ToDefaults TwipsToChartPart TypeByChartType
syn keyword vbMethods Update UpdateControls UpdateRecord UpdateRow Upto
syn keyword vbMethods WhatsThisMode WriteProperty ZOrder

syn keyword vbEvents AccessKeyPress AfterAddFile AfterChangeFileName
syn keyword vbEvents AfterCloseFile AfterColEdit AfterColUpdate
syn keyword vbEvents AfterDelete AfterInsert AfterLabelEdit AfterRemoveFile
syn keyword vbEvents AfterUpdate AfterWriteFile AmbienChanged ApplyChanges
syn keyword vbEvents Associate AsyncReadComplete AxisActivated AxisLabelActivated
syn keyword vbEvents AxisLabelSelected AxisLabelUpdated AxisSelected
syn keyword vbEvents AxisTitleActivated AxisTitleSelected AxisTitleUpdated
syn keyword vbEvents AxisUpdated BeforeClick BeforeColEdit BeforeColUpdate
syn keyword vbEvents BeforeConnect BeforeDelete BeforeInsert BeforeLabelEdit
syn keyword vbEvents BeforeLoadFile BeforeUpdate ButtonClick ButtonCompleted
syn keyword vbEvents ButtonGotFocus ButtonLostFocus Change ChartActivated
syn keyword vbEvents ChartSelected ChartUpdated Click ColEdit Collapse
syn keyword vbEvents ColResize ColumnClick Compare ConfigChageCancelled
syn keyword vbEvents ConfigChanged ConnectionRequest DataArrival DataChanged
syn keyword vbEvents DataUpdated DblClick Deactivate DeviceArrival
syn keyword vbEvents DeviceOtherEvent DeviceQueryRemove DeviceQueryRemoveFailed
syn keyword vbEvents DeviceRemoveComplete DeviceRemovePending DevModeChange
syn keyword vbEvents Disconnect DisplayChanged Dissociate DoGetNewFileName Done
syn keyword vbEvents DonePainting DownClick DragDrop DragOver DropDown
syn keyword vbEvents EditProperty EnterCell EnterFocus ExitFocus Expand
syn keyword vbEvents FootnoteActivated FootnoteSelected FootnoteUpdated GotFocus
syn keyword vbEvents HeadClick InfoMessage Initialize IniProperties ItemActivated
syn keyword vbEvents ItemAdded ItemCheck ItemClick ItemReloaded ItemRemoved
syn keyword vbEvents ItemRenamed ItemSeletected KeyDown KeyPress KeyUp LeaveCell
syn keyword vbEvents LegendActivated LegendSelected LegendUpdated LinkClose
syn keyword vbEvents LinkError LinkNotify LinkOpen Load LostFocus MouseDown
syn keyword vbEvents MouseMove MouseUp NodeClick ObjectMove OLECompleteDrag
syn keyword vbEvents OLEDragDrop OLEDragOver OLEGiveFeedback OLESetData
syn keyword vbEvents OLEStartDrag OnAddNew OnComm Paint PanelClick PanelDblClick
syn keyword vbEvents PathChange PatternChange PlotActivated PlotSelected
syn keyword vbEvents PlotUpdated PointActivated PointLabelActivated
syn keyword vbEvents PointLabelSelected PointLabelUpdated PointSelected
syn keyword vbEvents PointUpdated PowerQuerySuspend PowerResume PowerStatusChanged
syn keyword vbEvents PowerSuspend QueryChangeConfig QueryComplete QueryCompleted
syn keyword vbEvents QueryTimeout QueryUnload ReadProperties Reposition
syn keyword vbEvents RequestChangeFileName RequestWriteFile Resize ResultsChanged
syn keyword vbEvents RowColChange RowCurrencyChange RowResize RowStatusChanged
syn keyword vbEvents SelChange SelectionChanged SendComplete SendProgress
syn keyword vbEvents SeriesActivated SeriesSelected SeriesUpdated SettingChanged
syn keyword vbEvents SplitChange StateChanged StatusUpdate SysColorsChanged
syn keyword vbEvents Terminate TimeChanged TitleActivated TitleSelected
syn keyword vbEvents TitleActivated UnboundAddData UnboundDeleteRow
syn keyword vbEvents UnboundGetRelativeBookmark UnboundReadData UnboundWriteData
syn keyword vbEvents Unload UpClick Updated Validate ValidationError
syn keyword vbEvents WillAssociate WillChangeData WillDissociate WillExecute
syn keyword vbEvents WillUpdateRows WriteProperties

syn keyword vbTodo contained	TODO

"integer number, or floating point number without a dot.
syn match  vbNumber		"\<\d\+\>"
"floating point number, with dot
syn match  vbNumber		"\<\d\+\.\d*\>"
"floating point number, starting with a dot
syn match  vbNumber		"\.\d\+\>"

" String and Character contstants
syn region  vbString		  start=+"+  end=+"+
syn region  vbComment	start="REM" end="$" contains=vbTodo
syn region  vbComment   start="'"   end="$" contains=vbTodo
syn region  vbLineNumber	start="^\d" end="\s"
syn match   vbTypeSpecifier  "[a-zA-Z0-9][\$%&!#]"ms=s+1

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_vb_syntax_inits")
  if version < 508
    let did_vb_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink vbLineNumber	        Comment
  HiLink vbNumber		Number
  HiLink vbError		Error
  HiLink vbStatement	        Statement
  HiLink vbString		String
  HiLink vbComment		Comment
  HiLink vbTodo		Todo
  HiLink vbFunction		Identifier
  HiLink vbMethods             PreProc
  HiLink vbEvents              Special
  HiLink vbTypeSpecifier       Type

  delcommand HiLink
endif

let b:current_syntax = "vb"

" vim: ts=8
