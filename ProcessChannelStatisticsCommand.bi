#ifndef PROCESSCHANNELSTATISTICSCOMMAND_BI
#define PROCESSCHANNELSTATISTICSCOMMAND_BI

#include once "Bot.bi"

Declare Sub ProcessChannelStatisticsCommand( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal Channel As WString Ptr _
)

#endif
