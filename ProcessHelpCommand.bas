#include once "ProcessHelpCommand.bi"

Const AllUserCommands1 = "справка покажи жуйк . статистика кто з пенис guid"
Const AllUserCommands2 = "Описание можно почитать на сайте https://github.com/BatchedFiles/Qubick/blob/master/README.md"

Sub ProcessHelpCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	
	pBot->Say(Channel, @AllUserCommands1)
	pBot->Say(Channel, @AllUserCommands2)
End Sub