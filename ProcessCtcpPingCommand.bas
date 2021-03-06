#include once "ProcessCtcpPingCommand.bi"
#include once "IntegerToWString.bi"
#include once "DateTimeToString.bi"

Sub ProcessCtcpPingCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	lstrcpy(pBot->SavedChannel, Channel)
	lstrcpy(pBot->SavedUser, User)
	
	Dim CurrentSystemDateTicks As ULARGE_INTEGER = GetCurrentSystemDateTicks()
	
	Dim strCurrentSystemDateTicks As WString * 256 = Any
	ui64tow(CurrentSystemDateTicks.QuadPart, @strCurrentSystemDateTicks, 10)
	
	SendCtcpPingRequest(@pBot->Client, User, @strCurrentSystemDateTicks)
End Sub
