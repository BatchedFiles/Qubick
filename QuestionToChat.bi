#ifndef QUESTIONTOCHAT_BI
#define QUESTIONTOCHAT_BI

#include once "Bot.bi"

Declare Function QuestionToChat( _
	ByVal pBot As IrcBot Ptr, _
	ByVal User As WString Ptr, _
	ByVal MessageText As WString Ptr _
)As Boolean

#endif
