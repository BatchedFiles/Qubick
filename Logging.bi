#ifndef LOGGING_BI
#define LOGGING_BI

#include "Bot.bi"

Declare Sub LogIrcMessage( _
	ByVal pBot As IrcBot Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub LogUserJoined( _
	ByVal pBot As IrcBot Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr _
)

Declare Sub LogUserQuit( _
	ByVal pBot As IrcBot Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub LogPartChannel( _
	ByVal pBot As IrcBot Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub LogNickChanged( _
	ByVal pBot As IrcBot Ptr, _
	ByVal OldNick As WString Ptr, _
	ByVal NewNick As WString Ptr _
)

Declare Sub LogTopic( _
	ByVal pBot As IrcBot Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal UserName As WString Ptr, _
	ByVal TopicText As WString Ptr _
)

Declare Sub LogKick( _
	ByVal pBot As IrcBot Ptr, _
	ByVal AdminName As WString Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal KickedUser As WString Ptr _
)

#endif
