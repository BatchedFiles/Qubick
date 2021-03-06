#ifndef BOTEVENTS_BI
#define BOTEVENTS_BI

#include "IrcClient.bi"

Declare Sub SendedRawMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub ReceivedRawMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub ServerMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal IrcCommand As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub Notice( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal NoticeText As WString Ptr _
)

Declare Sub ChannelNotice( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal NoticeText As WString Ptr _
)

Declare Sub ChannelMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub IrcPrivateMessage( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub UserJoined( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr _
)

Declare Sub UserLeaved( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub NickChanged( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal NewNick As WString Ptr _
)

Declare Sub Topic( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal TopicText As WString Ptr _
)

Declare Sub UserQuit( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal MessageText As WString Ptr _
)

Declare Sub Kick( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal KickedUser As WString Ptr _
)

Declare Sub Invite( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal Channel As WString Ptr _
)

Declare Sub Ping( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Server As WString Ptr _
)

Declare Sub Pong( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Server As WString Ptr _
)

Declare Sub Mode( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Channel As WString Ptr, _
	ByVal Mode As WString Ptr, _
	ByVal UserName As WString Ptr _
)

Declare Sub ServerError( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal Message As WString Ptr _
)

Declare Sub CtcpPingRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr _
)

Declare Sub CtcpTimeRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr _
)

Declare Sub CtcpUserInfoRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr _
)

Declare Sub CtcpVersionRequest( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr _
)

Declare Sub CtcpAction( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal ActionText As WString Ptr _
)

Declare Sub CtcpPingResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr _
)

Declare Sub CtcpTimeResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal TimeValue As WString Ptr _
)

Declare Sub CtcpUserInfoResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal UserInfo As WString Ptr _
)

Declare Sub CtcpVersionResponse( _
	ByVal ClientData As Any Ptr, _
	ByVal pIrcPrefix As IrcPrefix Ptr, _
	ByVal ToUser As WString Ptr, _
	ByVal Version As WString Ptr _
)

#endif
