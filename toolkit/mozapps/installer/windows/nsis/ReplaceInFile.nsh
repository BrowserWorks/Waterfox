/*
First occurrence to be replaced: FST_OCC. 
   FST_OCC = all, renders the same as FST_OCC = 1.
   if FST_OCC greater than the number of occurences in the file: no alteration of the file,
   FST_OCC negative or 0 will leave the file content unchanged no matter the NR_OCC value. 
Nr max of occurrences replaced onwards: NR_OCC,
   if NR_OCC = all --> replacement as long as a string to be replaced is found,
   if NR_OCC = stritly positive integer, replaces up to NR_OCC occurrences provided they exist,   
   NR_OCC negative or 0 yields the same as all.
 
Order to run down and search the file: from left to right and top down.
REPLACEMENT_STR, OLD_STR, read line should be less than 1024 characters long. 
For NSIS Unicode, FILE_TO_MODIFIED must be utf-8 encoded.																	
*/
 
Var /Global OLD_STR
Var /Global FST_OCC
Var /Global NR_OCC
Var /Global REPLACEMENT_STR
Var /Global FILE_TO_MODIFIED
 
!macro ReplaceInFile OLD_STR FST_OCC NR_OCC REPLACEMENT_STR FILE_TO_MODIFIED
 
        Push "${OLD_STR}" ;text to be replaced
	Push "${REPLACEMENT_STR}" ;replace with
	Push "${FST_OCC}" ; starts replacing onwards FST_OCC occurrences
	Push "${NR_OCC}" ; replaces NR_OCC occurrences in all
	Push "${FILE_TO_MODIFIED}" ; file to replace in
	Call AdvReplaceInFile
 
!macroend
 
 
Function AdvReplaceInFile
Exch $0 ;FILE_TO_MODIFIED file to replace in
Exch
Exch $1 ;the NR_OCC of OLD_STR occurrences to be replaced.
Exch
Exch 2
Exch $2 ;FST_OCC: the first occurrence to be replaced and onwards
Exch 2
Exch 3
Exch $3 ;REPLACEMENT_STR string to replace with
Exch 3
Exch 4
Exch $4 ;OLD_STR to be replaced
Exch 4
Push $5 ;incrementing counter
Push $6 ;a chunk of read line
Push $7 ;the read line altered or not
Push $8 ;left string
Push $9 ;right string or forster read line
Push $R0 ;temp file handle
Push $R1 ;FILE_TO_MODIFIED file handle
Push $R2 ;a line read
Push $R3 ;the length of OLD_STR
Push $R4 ;counts reaching of FST_OCC
Push $R5 ;counts reaching of NR_OCC
Push $R6 ;temp file name
 
 
  GetTempFileName $R6
 
  FileOpen $R1 $0 r 			;FILE_TO_MODIFIED file to search in
  FileOpen $R0 $R6 w                    ;temp file
   StrLen $R3 $4			;the length of OLD_STR
   StrCpy $R4 0				;counter initialization
   StrCpy $R5 -1			;counter initialization
 
loop_read:
 ClearErrors
 FileRead $R1 $R2 			;reading line
 IfErrors exit				;when end of file has been reached
 
   StrCpy $5 -1  			;cursor, start of read line chunk
   StrLen $7 $R2 			;read line length
   IntOp $5 $5 - $7			;cursor initialization
   StrCpy $7 $R2			;$7 contains read line
 
loop_filter:
   IntOp $5 $5 + 1 			;cursor shifting
   StrCmp $5 0 file_write		;end of line has been reached
   StrCpy $6 $7 $R3 $5 			;a chunk of read line of length OLD_STR 
   StrCmp $6 $4 0 loop_filter		;continues to search OLD_STR if no match
 
StrCpy $8 $7 $5 			;left part 
IntOp $6 $5 + $R3
IntCmp $6 0 yes no			;left part + OLD_STR == full line read ?						
yes:
StrCpy $9 ""
Goto done
no:
StrCpy $9 $7 "" $6 			;right part
done:
StrCpy $9 $8$3$9 			;replacing OLD_STR by REPLACEMENT_STR in forster read line
 
IntOp $R4 $R4 + 1			;counter incrementation
;MessageBox MB_OK|MB_ICONINFORMATION \
;"count R4 = $R4, fst_occ = $2" 
StrCmp $2 all follow_up			;exchange ok, then goes to search the next OLD_STR
IntCmp $R4 $2 follow_up			;no exchange until FST_OCC has been reached,
Goto loop_filter			;and then searching for the next OLD_STR
 
follow_up:	
IntOp $R4 $R4 - 1			;now counter is to be stuck to FST_OCC
 
IntOp $R5 $R5 + 1			;counter incrementation
;MessageBox MB_OK|MB_ICONINFORMATION \
;"count R5 = $R5, nbr_occ = $1" 
StrCmp $1 all exchange_ok 		;goes to exchange OLD_STR with REPLACEMENT_STR
IntCmp $R5 $1 finalize			;proceeding exchange until NR_OCC has been reached														
 
exchange_ok:
IntOp $5 $5 + $R3 			;updating cursor
StrCpy $7 $9				;updating read line with forster read line
Goto loop_filter			;goes searching the same read line
 
finalize:
IntOp $R5 $R5 - 1			;now counter is to be stuck to NR_OCC
 
file_write: 
 FileWrite $R0 $7 			;writes altered or unaltered line 
Goto loop_read				;reads the next line
 
exit:
  FileClose $R0
  FileClose $R1
 
   ;SetDetailsPrint none
  Delete $0
  Rename $R6 $0				;superseding FILE_TO_MODIFIED file with
					;temp file built with REPLACEMENT_STR 
  ;Delete $R6
   ;SetDetailsPrint lastused
 
Pop $R6
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
Pop $9
Pop $8
Pop $7
Pop $6
Pop $5
;These values are stored in the stack in the reverse order they were pushed
Pop $0
Pop $1
Pop $2
Pop $3
Pop $4
FunctionEnd