#ifndef PROCESSCREATEGUIDCOMMAND_BI
#define PROCESSCREATEGUIDCOMMAND_BI

#include once "Bot.bi"

Declare Sub ProcessCreateGuidCommand( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal Channel As WString Ptr _
)

#endif
