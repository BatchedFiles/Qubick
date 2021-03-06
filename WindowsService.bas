#include once "WindowsService.bi"

Const ServiceName = "IrcBot"
Const SCMGoodByeMessageStop = "I am shutting down because Windows Service Controller sent a SERVICE_CONTROL_STOP message."
Const SCMGoodByeMessageShutdown = "I am shutting down because Windows Server is shutting down."
Const SCMInterrogateNotice = "Windows Service Controller sent a SERVICE_CONTROL_INTERROGATE message."
Const SCMNotImplementedNotice = "Windows Service Controller sent a not implemented message."

Function EntryPoint Alias "EntryPoint"()As Integer
	Dim DispatchTable(1) As SERVICE_TABLE_ENTRY = Any
	DispatchTable(0).lpServiceName = @ServiceName
	DispatchTable(0).lpServiceProc = @SvcMain
	DispatchTable(1).lpServiceName = 0
	DispatchTable(1).lpServiceProc = 0

	StartServiceCtrlDispatcher(@DispatchTable(0))
	Return 0
End Function

Sub SvcMain( _
		ByVal dwNumServicesArgs As DWORD, _
		ByVal lpServiceArgVectors As LPWSTR Ptr _
	)
	Dim Context As ServiceContext
	
	Context.ServiceStatusHandle = RegisterServiceCtrlHandlerEx(@ServiceName, @SvcCtrlHandlerEx, @Context)
	If Context.ServiceStatusHandle = 0 Then
		Exit Sub
	End If
	
	Context.ServiceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS
	Context.ServiceStatus.dwServiceSpecificExitCode = 0
	
	ReportSvcStatus(@Context, SERVICE_START_PENDING, NO_ERROR, 3000)
	
	InitializeIrcBot(@Context.Bot)
	
	ReportSvcStatus(@Context, SERVICE_START_PENDING, NO_ERROR, 3000)
	
	ReportSvcStatus(@Context, SERVICE_RUNNING, NO_ERROR, 0)
	
	MainLoop(@Context.Bot)
	
	ReportSvcStatus(@Context, SERVICE_STOPPED, NO_ERROR, 0)
End Sub

Function SvcCtrlHandlerEx( _
		ByVal dwCtrl As DWORD, _
		ByVal dwEventType As DWORD, _
		ByVal lpEventData As LPVOID, _
		ByVal lpContext As LPVOID _
	)As DWORD
	
	Dim pServiceContext As ServiceContext Ptr = lpContext
	
	Select Case dwCtrl
		Case SERVICE_CONTROL_INTERROGATE
			pServiceContext->Bot.SayToMainChannel(@SCMInterrogateNotice)
			ReportSvcStatus(pServiceContext, pServiceContext->ServiceStatus.dwCurrentState, NO_ERROR, 0)
			
		Case SERVICE_CONTROL_STOP
			ReportSvcStatus(pServiceContext, SERVICE_STOP_PENDING, NO_ERROR, 0)
			pServiceContext->Bot.ReconnectToServer = False
			QuitFromServer(@pServiceContext->Bot.Client, @SCMGoodByeMessageStop)
			
		Case SERVICE_CONTROL_SHUTDOWN
			ReportSvcStatus(pServiceContext, SERVICE_STOP_PENDING, NO_ERROR, 0)
			pServiceContext->Bot.ReconnectToServer = False
			QuitFromServer(@pServiceContext->Bot.Client, @SCMGoodByeMessageShutdown)
			
		Case Else
			pServiceContext->Bot.SayToMainChannel(@SCMNotImplementedNotice)
			Return ERROR_CALL_NOT_IMPLEMENTED
			
	End Select
	
	Return NO_ERROR
	
End Function

Sub ReportSvcStatus( _
		ByVal lpContext As ServiceContext Ptr, _
		ByVal dwCurrentState As DWORD, _
		ByVal dwWin32ExitCode As DWORD, _
		ByVal dwWaitHint As DWORD _
	)
	lpContext->ServiceStatus.dwCurrentState = dwCurrentState
	lpContext->ServiceStatus.dwWin32ExitCode = dwWin32ExitCode
	lpContext->ServiceStatus.dwWaitHint = dwWaitHint
	
	If dwCurrentState = SERVICE_START_PENDING Then
		lpContext->ServiceStatus.dwControlsAccepted = 0
	Else
		lpContext->ServiceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP Or SERVICE_ACCEPT_SHUTDOWN
	End If
	
	If dwCurrentState = SERVICE_RUNNING Or dwCurrentState = SERVICE_STOPPED Then
		lpContext->ServiceStatus.dwCheckPoint = 0
	Else
		lpContext->ServiceCheckPoint += 1
		lpContext->ServiceStatus.dwCheckPoint = lpContext->ServiceCheckPoint
	End If
	
	SetServiceStatus(lpContext->ServiceStatusHandle, @lpContext->ServiceStatus)
End Sub

EntryPoint()
