#ifndef PROCESSHELPCOMMAND_BI
#define PROCESSHELPCOMMAND_BI

#include once "Bot.bi"

Declare Sub ProcessHelpCommand( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal Channel As WString Ptr _
)

#endif
