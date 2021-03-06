#include once "BotCommands.bi"
#include once "StringFunctions.bi"

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"

Const HelpCommand1 =        "!help"
Const HelpCommand2 =        "!справка"
Const HelpCommand3 =        "!помощь"
Const ASCIICommand =        "!покажи"
Const ChatSayTextCommand1 = "чат, скажи: "
Const ChatSayTextCommand2 = "чат, "
Const StatsCommand =        "!статистика"
Const PingCommand =         "."
Const UserWhoIsCommand =    "!кто"
Const FenceCommand =        "!з"
Const PenisCommand =        "!пенис"
Const GuidCommand =         "!guid"
Const TimerCommand =        "!таймер"
Const JuickCommand =        "!жуйк"
Const GetLogsCommand =      "!история"

Const QuitCommand =         "!сгинь"
Const NickCommand =         "!ник"
Const JoinCommand =         "!зайди"
Const PartCommand =         "!выйди"
Const TopicCommand =        "!тема"
Const SayCommand =          "!скажи"
Const RawCommand =          "!ну"
Const ExecuteCommand =      "!делай"
Const PasswordCommand =     "!пароль"
Const AddQuestionCommand =  "!вопрос"
Const AddAnswerCommand =    "!ответ"
Const QuestionListCommand = "!вопросы"
Const AnswerListCommand =   "!ответы"

' Enum BotCommands
	' Quit
	' Nick
	' Join
	' Part
	' Topic
	' Say
	' Raw
	' NickservPassword
	' AddQuestion
	' AddAnswer
	' QuestionList
	' AnswerList

Function GetBotCommands( _
		ByVal MessageText As WString Ptr _
	)As BotCommands
	
	If lstrcmp(MessageText, @PingCommand) = 0 Then
		Return BotCommands.Ping
	End If
	
	If lstrcmp(MessageText, @HelpCommand1) = 0 Then
		Return BotCommands.Help
	End If
	
	If lstrcmp(MessageText, @HelpCommand2) = 0 Then
		Return BotCommands.Help
	End If
	
	If lstrcmp(MessageText, @HelpCommand3) = 0 Then
		Return BotCommands.Help
	End If
	
	If StartsWith(MessageText, @AsciiCommand) Then
		Return BotCommands.AsciiGraphics
	End If
	
	If StartsWith(MessageText, ChatSayTextCommand1) Then
		Return BotCommands.ChooseFromTwoOptions
	End If
	
	If StartsWith(MessageText, ChatSayTextCommand2) Then
		Return BotCommands.ChooseFromTwoOptions
	End If
	
	If lstrcmp(MessageText, @StatsCommand) = 0 Then
		Return BotCommands.Stats
	End If
	
	If lstrcmp(MessageText, @UserWhoIsCommand) = 0 Then
		Return BotCommands.UserWhoIs
	End If
	
	If StartsWith(MessageText, @TimerCommand) Then
		Return BotCommands.Timer
	End If
	
	If StartsWith(MessageText, @PenisCommand) Then
		Return BotCommands.Penis
	End If
	
	If StartsWith(MessageText, @ExecuteCommand) Then
		Return BotCommands.Execute
	End If
	
	If lstrcmp(MessageText, @GuidCommand) = 0 Then
		Return BotCommands.CreateGuid
	End If
	
	If lstrcmp(MessageText, @GetLogsCommand) = 0 Then
		Return BotCommands.GetLogs
	End If
	
	If StartsWith(MessageText, @JuickCommand) Then
		Return BotCommands.Execute
	End If
	
	If StartsWith(MessageText, @FenceCommand) Then
		Return BotCommands.Fence
	End If
	
	Return BotCommands.None
End Function
