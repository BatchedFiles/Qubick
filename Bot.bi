#ifndef BOT_BI
#define BOT_BI

#include once "IrcClient.bi"

' Задержка между сообщениями, чтобы не выгнали за флуд
Const MessageTimeWait As Integer = 3000

Type IrcBot
	Dim ExeDir As WString * (MAX_PATH + 1)
	Dim IniFileName As WString * (MAX_PATH + 1)
	Dim AsciiFileName As WString * (MAX_PATH + 1)
	Dim AnswersDatabaseFileName As WString * (MAX_PATH + 1)
	Dim ChannelLogsFileName As WString * (MAX_PATH + 1)
	Dim StatisticsFileName As WString * (MAX_PATH + 1)
	
	Dim IrcServer As WString * (IrcClient.MaxBytesCount + 1)
	Dim Port As WString * (IrcClient.MaxBytesCount + 1)
	Dim LocalAddress As WString * (IrcClient.MaxBytesCount + 1)
	Dim LocalPort As WString * (IrcClient.MaxBytesCount + 1)
	Dim ServerPassword As WString * (IrcClient.MaxBytesCount + 1)
	Dim BotNick As WString * (IrcClient.MaxBytesCount + 1)
	Dim UserString As WString * (IrcClient.MaxBytesCount + 1)
	Dim Description As WString * (IrcClient.MaxBytesCount + 1)
	Dim RealBotVersion As WString * (IrcClient.MaxBytesCount + 1)
	Dim AdminRealName As WString * (IrcClient.MaxBytesCount + 1)
	
	Dim AdminNick1 As WString * (IrcClient.MaxBytesCount + 1)
	Dim AdminNick2 As WString * (IrcClient.MaxBytesCount + 1)
	
	Dim Channels As WString * (IrcClient.MaxBytesCount + 1)
	Dim MainChannel As WString * (IrcClient.MaxBytesCount + 1)
	
	Dim ReconnectToServer As Boolean
	
	Dim InHandle As Handle
	Dim OutHandle As Handle
	Dim ErrorHandle As Handle
	
	Dim ReceivedRawMessagesCounter As UInteger
	Dim SendedRawMessagesCounter As UInteger
	
	Dim SavedChannel As WString * (IrcClient.MaxBytesCount + 1)
	Dim SavedUser As WString * (IrcClient.MaxBytesCount + 1)
	
	Dim AdminAuthenticated As Boolean
	
	Dim Client As IrcClient
	
	Declare Sub Say( _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
	Declare Sub SayToMainChannel( _
		ByVal MessageText As WString Ptr _
	)
	
	Declare Sub SayWithTimeOut( _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	
End Type

Declare Function InitializeIrcBot( _
	ByVal pBot As IrcBot Ptr _
)As Boolean

#endif
