#ifndef COMMANDS_BI
#define COMMANDS_BI

Enum BotCommands
	None
	Ping
	Help
	AsciiGraphics
	Fence
	ChooseFromTwoOptions
	Stats
	UserWhoIs
	Timer
	Penis
	Quit
	Nick
	Join
	Part
	Topic
	Say
	Raw
	Execute
	NickservPassword
	AddQuestion
	AddAnswer
	QuestionList
	AnswerList
	CreateGuid
	Juick
	GetLogs
End Enum

Declare Function GetBotCommands( _
	ByVal MessageText As WString Ptr _
)As BotCommands

#endif
