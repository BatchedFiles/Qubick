#ifndef PROCESSUSERWHOISCOMMAND_BI
#define PROCESSUSERWHOISCOMMAND_BI

#include once "Bot.bi"

Declare Sub ProcessUserWhoIsCommand( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal Channel As WString Ptr _
)

#endif
