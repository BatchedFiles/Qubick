#include once "BotEvents.bi"
#include once "IrcReplies.bi"
#include once "Bot.bi"
#include once "Settings.bi"
#include once "ProcessCommands.bi"
#include once "QuestionToChat.bi"
#include once "AnswerToChat.bi"
#include once "WriteLine.bi"
#include once "CharConstants.bi"
#include once "IntegerToWString.bi"
#include once "DateTimeToString.bi"
#include once "Logging.bi"

Const NickServNick = "NickServ"
Const PasswordKey = "NickServPassword"

Sub ChannelMessage( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	LogIrcMessage(pBot, Channel, pIrcPrefix->Nick, MessageText)
	
	IncrementUserWords(Channel, pIrcPrefix->Nick)
	
	If ProcessUserCommand(pBot, pIrcPrefix->Nick, Channel, MessageText) Then
		Exit Sub
	End If
	
	If QuestionToChat(pBot, Channel, MessageText) Then
		Exit Sub
	End If
	
	AnswerToChat(pBot, Channel, MessageText)
	
End Sub

Sub ServerMessage( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal IrcCommand As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	If lstrcmp(IrcCommand, @RPL_WELCOME) = 0 Then
		Dim PasswordBuffer As WString * (IrcClient.MaxBytesCount + 1) = Any
		Dim Result As Integer = GetSettingsValue(@PasswordBuffer, IrcClient.MaxBytesCount, @PasswordKey)
		
		If Result <> -1 Then
			
			If lstrlen(@PasswordBuffer) > 0 Then
				Dim Buffer As WString * (IrcClient.MaxBytesCount + 1) = Any
				lstrcpy(@Buffer, "IDENTIFY ")
				lstrcat(@Buffer, @PasswordBuffer)
				SendIrcMessage(@pBot->Client, @NickServNick, @Buffer)
			End If
		End If
		
		JoinChannel(@pBot->Client, @pBot->Channels)
		
		Exit Sub
	End If
	
	If lstrcmp(IrcCommand, @RPL_WHOISLOGGEDAS) = 0 Then
		':orwell.freenode.net 330 Station922_mkv PERDOLIKS writed :is logged in as
		Dim WordsCount As Long = Any
		Dim Lines As WString Ptr Ptr = CommandLineToArgvW(MessageText, @WordsCount)
		
		If WordsCount > 4 Then
			If lstrcmp(Lines[1], @pbot->AdminNick1) = 0 OrElse lstrcmp(Lines[1], @pBot->AdminNick2) = 0 Then
				If lstrcmp(Lines[2], @pbot->AdminNick1) = 0 Then
					If StrStr(MessageText, ":is logged in as") <> 0 Then
						pBot->AdminAuthenticated = True
						If lstrlen(pBot->SavedChannel) <> 0 Then
							pBot->Say(pBot->SavedChannel, @"Аутентификация успешно пройдена.")
							pBot->SavedChannel[0] = 0
						End If
					End If
				End If
			Else
				If lstrlen(pBot->SavedChannel) <> 0 Then
					pBot->Say(pBot->SavedChannel, @"Ты никто и судьбы твоей нет. Ты проиграл свою душу, она не принадлежит тебе уже.")
					pBot->SavedChannel[0] = 0
				End If
			End If
		End If
		
		LocalFree(Lines)
		Exit Sub
	End If
	
	If lstrcmp(IrcCommand, @RPL_NAMREPLY) = 0 Then
		Dim wStart As WString Ptr = StrChr(MessageText, ColonChar)
		If wStart <> 0 Then
			wStart += 1
			' Список пользователей в дерево
			Dim WordsCount As Long = Any
			Dim Lines As WString Ptr Ptr = CommandLineToArgvW(MessageText, @WordsCount)
			
			LocalFree(Lines)
		End If
		Exit Sub
	End If
End Sub

Sub UserJoined( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal Channel As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	Dim wChannel As WString Ptr = Any
	If Channel[0] = ColonChar Then
		wChannel = @Channel[1]
	Else
		wChannel = @Channel[0]
	End If
	
	LogUserJoined(pBot, wChannel, pIrcPrefix->Nick)
	
	If lstrcmp(@pbot->MainChannel, wChannel) <> 0 Then
		Exit Sub
	End If
	
	If lstrcmp(pBot->BotNick, pIrcPrefix->Nick) <> 0 Then
		SendCtcpVersionRequest(@pBot->Client, pIrcPrefix->Nick)
	End If
End Sub

Sub UserLeaved( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	LogPartChannel(pBot, Channel, pIrcPrefix->Nick, MessageText)
End Sub

Sub UserQuit( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	LogUserQuit(pBot, pIrcPrefix->Nick, MessageText)
	
	If lstrcmp(pIrcPrefix->Nick, @pBot->AdminNick1) = 0 OrElse lstrcmp(pIrcPrefix->Nick, @pBot->AdminNick2) = 0 Then
		pBot->AdminAuthenticated = False
	End If
End Sub

Sub NickChanged( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal NewNick As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	LogNickChanged(pBot, pIrcPrefix->Nick, NewNick)
	
	If lstrcmp(pIrcPrefix->Nick, @pbot->AdminNick1) = 0 Then
		pBot->AdminAuthenticated = False
	End If
	If lstrcmp(pIrcPrefix->Nick, @pbot->AdminNick2) = 0 Then
		pBot->AdminAuthenticated = False
	End If
End Sub

Sub Ping( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal Server As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	SendPong(@pBot->Client, Server)
End Sub

Sub CtcpPingResponse( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	Dim CurrentSystemDateTicks As ULARGE_INTEGER = GetCurrentSystemDateTicks()
	
	If lstrcmp(pIrcPrefix->Nick, ToUser) = 0 Then
		Exit Sub
	End If
	
	If lstrlen(pBot->SavedChannel) = 0 Then
		Exit Sub
	End If
	
	Dim UserDateTicks As ULARGE_INTEGER = Any
	If StrToInt64Ex(TimeValue, STIF_DEFAULT, @UserDateTicks.QuadPart) = 0 Then
		Exit Sub
	End If
	
	Dim UserDelay As Integer = CurrentSystemDateTicks.QuadPart - UserDateTicks.QuadPart
	UserDelay = UserDelay \ 100
	UserDelay = UserDelay \ 2
	
	Dim strUserDelay As WString * (IrcClient.MaxBytesCount + 1) = Any
	lstrcpy(@strUserDelay, pBot->SavedUser)
	lstrcat(@strUserDelay, ": ping from you ")
	itow(UserDelay, @strUserDelay + lstrlen(@strUserDelay), 10)
	lstrcat(@strUserDelay, " microseconds.")
	
	pBot->Say(pBot->SavedChannel, @strUserDelay)
	pBot->SavedChannel[0] = 0
End Sub

Sub CtcpVersionResponse( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal ToUser As WString Ptr, _
		ByVal Version As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	
	If lstrcmp(pIrcPrefix->Nick, ToUser) <> 0 Then
		Dim ClientVersion As WString * (IrcClient.MaxBytesCount + 1)
		lstrcpy(@ClientVersion, pIrcPrefix->Nick)
		lstrcat(@ClientVersion, @" is using ")
		lstrcat(@ClientVersion, Version)
		pBot->SayToMainChannel(@ClientVersion)
	End If
End Sub

Sub Kick( _
		ByVal ClientData As Any Ptr, _
		ByVal pIrcPrefix As IrcPrefix Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal KickedUser As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	JoinChannel(@pBot->Client, Channel)
End Sub

Sub SendedRawMessage( _
		ByVal ClientData As Any Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	pBot->SendedRawMessagesCounter += 1
	
	#ifndef service
	WriteLine(pBot->OutHandle, MessageText)
	#endif
	
End Sub

Sub ReceivedRawMessage( _
		ByVal ClientData As Any Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim pBot As IrcBot Ptr = CPtr(IrcBot Ptr, ClientData)
	pBot->ReceivedRawMessagesCounter += 1
	
	#ifndef service
	WriteLine(pBot->OutHandle, MessageText)
	#endif
	
End Sub
