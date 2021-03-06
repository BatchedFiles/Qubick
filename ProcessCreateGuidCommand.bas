#include "ProcessCreateGuidCommand.bi"

#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\ole2.bi"

Sub ProcessCreateGuidCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	Dim NewGuid As GUID = Any
	Dim hr As HRESULT = CoCreateGuid(@NewGuid)
	If FAILED(hr) Then
		Return
	End If
	
	Dim NewClsids As WString Ptr = Any
	hr = StringFromCLSID(@NewGuid, @NewClsids)
	If FAILED(hr) Then
		Return
	End If
	
	pBot->Say(Channel, NewClsids)
	
	CoTaskMemFree(NewClsids)
End Sub
