#ifndef PROCESSGETLOGSCOMMAND_BI
#define PROCESSGETLOGSCOMMAND_BI

#include once "Bot.bi"

Declare Sub ProcessGetLogsCommand( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal Channel As WString Ptr _
)

#endif
