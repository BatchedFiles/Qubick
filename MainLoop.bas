#include once "MainLoop.bi"
#include once "Bot.bi"

Const TenMinutesInMilliSeconds As DWORD = 10 * 60 * 1000

Function MainLoop(ByVal lpParam As LPVOID)As DWORD
	Dim pBot As IrcBot Ptr = lpParam
	
	Dim objWsaData As WSAData = Any
	If WSAStartup(MAKEWORD(2, 2), @objWsaData) <> 0 Then
		Return 1
	End If
	
	Do
		If OpenIrcClient(@pBot->Client, @pBot->IrcServer, @pBot->Port, @pBot->LocalAddress, @pBot->LocalPort, @pBot->ServerPassword, @pBot->BotNick, @pBot->UserString, @pBot->Description, True) Then
			Do While pBot->Client.ClientConnected
				If SleepEx(TenMinutesInMilliSeconds, True) = 0 Then
					CloseIrcClient(@pBot->Client)
				End If
			Loop
		End If
	Loop While pBot->ReconnectToServer
	
	WSACleanup()
	
	Return 0
End Function
