#ifndef DCCSENDSERVER_BI
#define DCCSENDSERVER_BI

#include "Bot.bi"

Declare Sub DccSendFileToClient( _
	ByVal pBot As IrcBot Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal LocalAddress As WString Ptr, _
	ByVal FileFullPath As WString Ptr, _
	ByVal ClientFileName As WString Ptr _
)

#endif
