#include once "MainLoop.bi"
#include once "Bot.bi"

Const TenMinutesInMilliSeconds As DWORD = 10 * 60 * 1000

Function MainLoop(ByVal lpParam As LPVOID)As DWORD
	Dim pBot As IrcBot Ptr = lpParam
	
	Dim objWsaData As WSAData = Any
	If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> 0 Then
		Return 1
	End If
	
	Dim bOpenIrcClientResult As Boolean = OpenIrcClient( _
		@pBot->Client, _
		@pBot->IrcServer, _
		@pBot->Port, _
		@pBot->LocalAddress, _
		@pBot->LocalPort, _
		@pBot->ServerPassword, _
		@pBot->BotNick, _
		@pBot->UserString, _
		@pBot->Description, _
		True _
	)
	
	Do While pBot->ReconnectToServer
		
		If bOpenIrcClientResult = False Then
			SleepEx(60 * 1000, True)
		Else
			Do While WaitForSingleObjectEx(pBot->Client.hEvent, TenMinutesInMilliSeconds, True) = WAIT_IO_COMPLETION
			
			Loop
		End If
		
		bOpenIrcClientResult = OpenIrcClient( _
			@pBot->Client, _
			@pBot->IrcServer, _
			@pBot->Port, _
			@pBot->LocalAddress, _
			@pBot->LocalPort, _
			@pBot->ServerPassword, _
			@pBot->BotNick, _
			@pBot->UserString, _
			@pBot->Description, _
			True _
		)
	Loop
	
	WSACleanup()
	
	Return 0
End Function
