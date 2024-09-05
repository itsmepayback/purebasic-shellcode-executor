; This Is the 'Function' Prototype That Allows Our Shellcode Execution
Prototype Function()

  Runtime Procedure Function1()
     
  EndProcedure
  ; Call The ShellCode Using A Function Prototype
  Procedure Main(zzz)
  Protected lol.Function = zzz
  lol()
EndProcedure

;Done To Allow The 32-Bit Program To Open A  Shellcode File Even In A 64-Bit Directory
Procedure DisableWowRedirection()
    OpenLibrary(0, "Kernel32.dll")
     GetFunction(0, "IsWow64Process")
     CallFunction(0,"IsWow64Process",GetCurrentProcess_(), @IsWow64ProcessFlag)
 If IsWow64ProcessFlag <> 0 
     CompilerIf  #PB_Compiler_Processor =  #PB_Processor_x86
         wfd.WIN32_FIND_DATA
         GetFunction(0, "Wow64DisableWow64FsRedirection") 
         CallFunction(0,"Wow64DisableWow64FsRedirection",Flag)
         CloseLibrary(0)
       CompilerEndIf
       EndIf
  EndProcedure
  
  
 
       
      

       Procedure ExecFile(fi$)
         Protected *sus, *MemoryID
   If ReadFile(0, fi$)
      length = Lof(0)                            ; get the length of opened file
      *MemoryID = AllocateMemory(length)         ; allocate the needed memory
      If *MemoryID
        bytes = ReadData(0, *MemoryID, length) 
       
        ; Allocate Virtual Read-Write-Execute Memory For Our Shellcode
        *sus = VirtualAlloc_(0, MemorySize(*MemoryID), #MEM_COMMIT, #PAGE_EXECUTE_READWRITE)
        ; Copy The Shellcode To The Virtual Memory
        CopyMemory(*MemoryID, *sus, MemorySize(*MemoryID))
       Main(*sus)
      EndIf
      CloseFile(0)
   
      
   
  Else
    MessageBox_(0, "Unable To Open The Requested File. Maybe Check Its Permissions?", "Error", #MB_OK|#MB_ICONERROR)
    EndIf
  ProcedureReturn 0
EndProcedure



;SetErrorMode_(#SEM_NOGPFAULTERRORBOX)
DisableWowRedirection()
CmdLine$ = ProgramParameter(0)
If CmdLine$
  ExecFile(CmdLine$)
Else
  
; Open File Dialog To Select Our Shellcode
file2exec$ = OpenFileRequester("Choose A Shellcode File To Execute",
                                "", "Binary Files | *.bin", 0)

If file2exec$
 
    ExecFile(file2exec$)
Else
  MessageBox_(0, "An Unkown Error Has Occured While Trying To Execute The Shellcode.", "Error", #MB_OK | #MB_ICONERROR) ; fix the error message to a more useful one
EndIf
EndIf
; IDE Options = PureBasic 6.04 LTS (Windows - x86)
; CursorPosition = 73
; FirstLine = 2
; Folding = -
; Optimizer
; EnableThread
; DPIAware
; Executable = shexec.exe
; CPU = 1