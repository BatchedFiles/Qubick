#include once "Main.bi"
#include once "Bot.bi"
#include once "MainLoop.bi"
#include "WithoutRuntime.bi"

BeginMainFunction
	
	Dim pBot As IrcBot = Any
	InitializeIrcBot(@pBot)
	
	RetCode(MainLoop(@pBot))
	
EndMainFunction
