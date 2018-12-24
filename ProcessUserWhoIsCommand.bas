#include once "ProcessUserWhoIsCommand.bi"

Sub ProcessUserWhoIsCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	lstrcpy(pBot->SavedChannel, Channel)
	lstrcpy(pBot->SavedUser, User)
	
	SendWhoIs(@pBot->Client, User)
End Sub
