#include once "DateTimeToString.bi"

Const DateFormatString = "ddd, dd MMM yyyy "
Const TimeFormatString = "HH:mm:ss GMT"

Sub GetHttpDate( _
		ByVal Buffer As WString Ptr, _
		ByVal dt As SYSTEMTIME Ptr _
	)
	' Tue, 15 Nov 1994 12:45:26 GMT
	Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, dt, @DateFormatString, Buffer, 31) - 1
	GetTimeFormat(LOCALE_INVARIANT, 0, dt, @TimeFormatString, @Buffer[dtBufferLength], 31 - dtBufferLength)
End Sub

Sub GetHttpDate( _
		ByVal Buffer As WString Ptr _
	)
	Dim dt As SYSTEMTIME = Any
	GetSystemTime(@dt)
	GetHttpDate(Buffer, @dt)
End Sub

Function GetCurrentSystemDateTicks( _
	)As ULARGE_INTEGER
	
	Dim CurrentSystemDate As SYSTEMTIME
	GetSystemTime(@CurrentSystemDate)
	
	Dim CurrentSystemFileDate As FILETIME
	SystemTimeToFileTime(@CurrentSystemDate, @CurrentSystemFileDate)
	
	Dim CurrentSystemDateTicks As ULARGE_INTEGER
	CurrentSystemDateTicks.LowPart = CurrentSystemFileDate.dwLowDateTime
	CurrentSystemDateTicks.HighPart = CurrentSystemFileDate.dwHighDateTime
	
	Return CurrentSystemDateTicks
End Function
