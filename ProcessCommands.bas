#include once "ProcessCommands.bi"
#include once "BotCommands.bi"
#include once "ProcessCtcpPingCommand.bi"
#include once "ProcessFenceCommand.bi"
#include once "ProcessHelpCommand.bi"
#include once "ProcessAsciiGraphicsCommand.bi"
#include once "ProcessChooseFromTwoOptionsCommand.bi"
#include once "ProcessChannelStatisticsCommand.bi"
#include once "ProcessUserWhoIsCommand.bi"
#include once "ProcessTimerCommand.bi"
#include once "ProcessPenisCommand.bi"
#include once "ProcessExecuteCommand.bi"
#include once "ProcessCreateGuidCommand.bi"
#include once "ProcessGetLogsCommand.bi"

Function ValidateAdminLogin( _
		ByVal pBot As IrcBot Ptr, _
		ByVal UserName As WString Ptr _
	)As Boolean
	If lstrcmp(UserName, @pBot->AdminNick1) = 0 OrElse lstrcmp(UserName, @pBot->AdminNick2) = 0 Then
		If pBot->AdminAuthenticated Then
			Return True
		End If
	End If
	Return False
End Function

Function ProcessUserCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As Boolean
	
	Dim BotCommand As BotCommands = GetBotCommands(MessageText)
	
	Select Case BotCommand
		
		Case BotCommands.Ping
			ProcessCtcpPingCommand(pBot, User, Channel)
			
		Case BotCommands.Help
			ProcessHelpCommand(pBot, User, Channel)
			
		Case BotCommands.AsciiGraphics
			ProcessAsciiGraphicsCommand(pBot, User, Channel, MessageText)
			
		Case BotCommands.Fence
			ProcessFenceCommand(pBot, User, Channel, MessageText)
			
		Case BotCommands.ChooseFromTwoOptions
			ProcessChooseFromTwoOptionsCommand(pBot, User, Channel, MessageText)
			
		Case BotCommands.Stats
			ProcessChannelStatisticsCommand(pBot, User, Channel)
			
		Case BotCommands.UserWhoIs
			ProcessUserWhoIsCommand(pBot, User, Channel)
			
		Case BotCommands.Timer
			ProcessTimerCommand(pBot, User, Channel, MessageText)
			
		Case BotCommands.Penis
			ProcessPenisCommand(pBot, User, Channel, MessageText)
			
		Case BotCommands.CreateGuid
			ProcessCreateGuidCommand(pBot, User, Channel)
			
		Case BotCommands.GetLogs
			ProcessGetLogsCommand(pBot, User, Channel)
			
		Case Else
			If ValidateAdminLogin(pBot, User) = False Then
				Return False
			End If
			
			Select Case BotCommand
				Case BotCommands.Quit
					
				Case BotCommands.Nick
					
				Case BotCommands.Join
					
				Case BotCommands.Part
					
				Case BotCommands.Topic
					
				Case BotCommands.Say
					
				Case BotCommands.Raw
					
				Case BotCommands.Execute
					ProcessExecuteCommand(pBot, User, Channel, MessageText)
					
				Case BotCommands.NickservPassword
					
				Case BotCommands.AddQuestion
					
				Case BotCommands.AddAnswer
					
				Case BotCommands.QuestionList
					
				Case BotCommands.AnswerList
					
				Case Else
					Return False
					
			End Select
	End Select
	
	Return True
	
End Function