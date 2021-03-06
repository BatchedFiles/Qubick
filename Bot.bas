#ifndef unicode
#define unicode
#endif
#include once "bot.bi"
#include once "BotEvents.bi"
#include once "IntegerToWString.bi"
#include once "Settings.bi"
#include once "Resources.rh"
#include once "Logging.bi"

Const DefaultIniFileName = "Qubick.ini"
Const AsciiFileName = "ascii.txt"
Const AnswersDatabaseFileName = "QubickAnswers.txt"
Const ChannelLogsFileName = "ChannelLogs.xml"
Const StatisticsFileName = "channelstats.xml"

Const DefaultIrcServer = "chat.freenode.net"
Const DefaultPort = "6667"
Const DefaultLocalAddress = "0.0.0.0"
Const DefaultLocalPort = "0"

#if __FB_DEBUG__ <> 0
Const DefaultBotNick = "Station922_mkv"
#else
Const DefaultBotNick = "Qubick"
#endif

Const DefaultUserString = "Qubick"
Const DefaultDescription = "Irc bot written in FreeBASIC"
Const DefaultRealName = "Qubick"

Const DefaultChannels = "#s2ch,#freebasic-ru"
Const DefaultMainChannel = "#freebasic-ru"
Const DefaultAdminNick1 = "writed"

' Версия бота \ Версия ОС \ Процессор \ Физическая память всего
' HexChat 2.12.4 [x86] / Microsoft Windows 10 Pro (x64) [Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz (3.60GHz)] via ZNC - http://znc.in
Const BotVersion1 = "IrcBot version "
Const BotVersion2 = " \ FreeBASIC \ Microsoft Windows "

Const ConnectionSectionString = "Connection"
Const IrcBotSectionString = "IrcBot"

Const ServerKeyString = "Server"
Const PortKeyString = "Port"
Const LocalAddressKeyString = "LocalAddress"
Const LocalPortKeyString = "LocalPort"
Const NickKeyString = "Nick"
Const ServerPasswordKeyString = "ServerPassword"
Const UserKeyString = "UserString"
Const DescriptionKeyString = "Description"
Const RealNameKeyString = "RealName"
Const ChannelsKeyString = "Channels"
Const MainChannelKeyString = "MainChannel"

Const AdminNick1KeyString = "AdminNick1"
Const AdminNick2KeyString = "AdminNick2"

Sub MakeBotVersion(ByVal Version As WString Ptr)
	lstrcpy(Version, @BotVersion1)
	lstrcat(Version, @VER_PRODUCTVERSION_STR)
	Dim VersionLength As Integer = lstrlen(Version)
	lstrcpy(Version + VersionLength - 2, @BotVersion2)
	
	Dim osVersion As OsVersionInfoEx
	osVersion.dwOSVersionInfoSize = SizeOf(OsVersionInfoEx)
	
	If GetVersionEx(CPtr(OsVersionInfo Ptr, @osVersion)) <> 0 Then
		Scope
			Dim strNumber As WString * 256 = Any
			itow(osVersion.dwMajorVersion, @strNumber, 10)
			lstrcat(Version, @strNumber)
			lstrcat(Version, @".")
		End Scope
		
		Scope
			Dim strNumber As WString * 256 = Any
			itow(osVersion.dwMinorVersion, @strNumber, 10)
			lstrcat(Version, @strNumber)
			lstrcat(Version, @".")
		End Scope
		
		Scope
			Dim strNumber As WString * 256 = Any
			itow(osVersion.dwBuildNumber, @strNumber, 10)
			lstrcat(Version, @strNumber)
		End Scope
	End If
End Sub

Function InitializeIrcBot( _
		ByVal pBot As IrcBot Ptr _
	)As Boolean
	
	' Имя исполняемого файла
	Dim ExeFileName As WString * (MAX_PATH + 1) = Any
	Dim ExeFileNameLength As DWORD = GetModuleFileName(0, @ExeFileName, MAX_PATH)
	If ExeFileNameLength = 0 Then
		Return False
	End If
	
	lstrcpy(@pBot->ExeDir, @ExeFileName)
	PathRemoveFileSpec(@pBot->ExeDir)
	
	' Файл с настройками
	PathCombine(@pBot->IniFileName, @pBot->ExeDir, @DefaultIniFileName)
	PathCombine(@pBot->AsciiFileName, @pBot->ExeDir, @AsciiFileName)
	PathCombine(@pBot->AnswersDatabaseFileName, @pBot->ExeDir, @AnswersDatabaseFileName)
	PathCombine(@pBot->ChannelLogsFileName, @pBot->ExeDir, @ChannelLogsFileName)
	PathCombine(@pBot->StatisticsFileName, @pBot->ExeDir, @StatisticsFileName)
	
	GetPrivateProfileString(@ConnectionSectionString, @ServerKeyString, @DefaultIrcServer, @pBot->IrcServer, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@ConnectionSectionString, @PortKeyString, @DefaultPort, @pBot->Port, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@ConnectionSectionString, @LocalAddressKeyString, @DefaultLocalAddress, @pBot->LocalAddress, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@ConnectionSectionString, @LocalPortKeyString, @DefaultLocalPort, @pBot->LocalPort, IrcClient.MaxBytesCount, @pBot->IniFileName)
	
	GetPrivateProfileString(@IrcBotSectionString, @ServerPasswordKeyString, @"", @pBot->ServerPassword, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @NickKeyString, @DefaultBotNick, @pBot->BotNick, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @UserKeyString, @DefaultUserString, @pBot->UserString, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @DescriptionKeyString, @DefaultDescription, @pBot->Description, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @RealNameKeyString, @DefaultRealName, @pBot->AdminRealName, IrcClient.MaxBytesCount, @pBot->IniFileName)
	
	GetPrivateProfileString(@IrcBotSectionString, @ChannelsKeyString, @DefaultChannels, @pBot->Channels, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @MainChannelKeyString, @DefaultMainChannel, @pBot->MainChannel, IrcClient.MaxBytesCount, @pBot->IniFileName)
	
	GetPrivateProfileString(@IrcBotSectionString, @AdminNick1KeyString, @DefaultAdminNick1, @pBot->AdminNick1, IrcClient.MaxBytesCount, @pBot->IniFileName)
	GetPrivateProfileString(@IrcBotSectionString, @AdminNick2KeyString, @DefaultAdminNick1, @pBot->AdminNick2, IrcClient.MaxBytesCount, @pBot->IniFileName)
	
	pBot->ReconnectToServer = True
	
	pBot->InHandle = GetStdHandle(STD_INPUT_HANDLE)
	pBot->OutHandle = GetStdHandle(STD_OUTPUT_HANDLE)
	pBot->ErrorHandle = GetStdHandle(STD_ERROR_HANDLE)
	
	pBot->ReceivedRawMessagesCounter = 0
	pBot->SendedRawMessagesCounter = 0
	
	pBot->SavedChannel[0] = 0
	pBot->SavedUser[0] = 0
	
	pBot->AdminAuthenticated = False
	
	pBot->Client.AdvancedClientData = pBot
	pBot->Client.CodePage = CP_UTF8
	pBot->Client.ClientUserInfo = @pBot->AdminRealName
	
	MakeBotVersion(@pBot->RealBotVersion)
	
	pBot->Client.ClientVersion = @pBot->RealBotVersion
	
	pBot->Client.lpfnSendedRawMessageEvent = @SendedRawMessage
	pBot->Client.lpfnReceivedRawMessageEvent = @ReceivedRawMessage
	pBot->Client.lpfnServerMessageEvent = @ServerMessage
	pBot->Client.lpfnChannelMessageEvent = @ChannelMessage
	pBot->Client.lpfnPrivateMessageEvent = 0
	pBot->Client.lpfnUserJoinedEvent = @UserJoined
	pBot->Client.lpfnServerErrorEvent = 0
	pBot->Client.lpfnNoticeEvent = 0
	pBot->Client.lpfnChannelNoticeEvent = 0
	pBot->Client.lpfnUserLeavedEvent = @UserLeaved
	pBot->Client.lpfnNickChangedEvent = @NickChanged
	pBot->Client.lpfnTopicEvent = 0
	pBot->Client.lpfnQuitEvent = @UserQuit
	pBot->Client.lpfnKickEvent = @Kick
	pBot->Client.lpfnInviteEvent = 0
	pBot->Client.lpfnPingEvent = 0
	pBot->Client.lpfnPongEvent = 0
	pBot->Client.lpfnModeEvent = 0
	pBot->Client.lpfnCtcpPingRequestEvent = 0
	pBot->Client.lpfnCtcpTimeRequestEvent = 0
	pBot->Client.lpfnCtcpUserInfoRequestEvent = 0
	pBot->Client.lpfnCtcpVersionRequestEvent = 0
	pBot->Client.lpfnCtcpActionEvent = 0
	pBot->Client.lpfnCtcpPingResponseEvent = @CtcpPingResponse
	pBot->Client.lpfnCtcpTimeResponseEvent = 0
	pBot->Client.lpfnCtcpUserInfoResponseEvent = 0
	pBot->Client.lpfnCtcpVersionResponseEvent = @CtcpVersionResponse
	
End Function

Sub IrcBot.SayToMainChannel( _
		ByVal MessageText As WString Ptr _
	)
	Say(@MainChannel, MessageText)
End Sub

Sub IrcBot.SayWithTimeOut( _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Say(Channel, MessageText)
	SleepEx(MessageTimeWait, True)
End Sub

Sub IrcBot.Say( _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	LogIrcMessage(@this, Channel, @BotNick, MessageText)
	IncrementUserWords(Channel, @BotNick)
	SendIrcMessage(@Client, Channel, MessageText)
End Sub
