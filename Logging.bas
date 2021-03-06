#include "Logging.bi"
#include "DateTimeToString.bi"
#include once "CharConstants.bi"

Const XmlStart = "<?xml version=""1.0"" encoding=""utf-8"" ?><!DOCTYPE ircChannelLogs [<!ELEMENT ircChannelLogs (privmsgEntry | joinEntry | quitEntry | partEntry | nickEntry | topicEntry | kickEntry)*><!ELEMENT privmsgEntry (channel, nick, message)><!ATTLIST privmsgEntry httpDate CDATA #REQUIRED><!ELEMENT joinEntry (channel, nick)><!ATTLIST joinEntry httpDate CDATA #REQUIRED><!ELEMENT quitEntry (nick, message)><!ATTLIST quitEntry httpDate CDATA #REQUIRED><!ELEMENT partEntry (channel, nick, message)><!ATTLIST partEntry httpDate CDATA #REQUIRED><!ELEMENT topicEntry (channel, nick, message)><!ATTLIST topicEntry httpDate CDATA #REQUIRED><!ELEMENT kickEntry (channel, admin, kickedNick)><!ATTLIST kickEntry httpDate CDATA #REQUIRED><!ELEMENT nickEntry (oldNick, newNick)><!ATTLIST nickEntry httpDate CDATA #REQUIRED><!ELEMENT channel (#PCDATA)><!ELEMENT nick (#PCDATA)><!ELEMENT message (#PCDATA)><!ELEMENT oldNick (#PCDATA)><!ELEMENT newNick (#PCDATA)><!ELEMENT admin (#PCDATA)><!ELEMENT kickedNick (#PCDATA)>]><ircChannelLogs>"

Const XmlEnd = "</ircChannelLogs>"

Function GetHtmlSafeString( _
		ByVal Buffer As WString Ptr, _
		ByVal BufferLength As Integer, _
		ByVal HtmlSafe As WString Ptr, _
		ByVal pHtmlSafeLength As Integer Ptr _
	)As Boolean
	
	Const MaxQuotationMarkSafeStringLength As Integer = 6
	Const MaxAmpersandSafeStringLength As Integer = 5
	Const MaxApostropheSafeStringLength As Integer = 6
	Const MaxLessThanSignSafeStringLength As Integer = 4
	Const MaxGreaterThanSignSafeStringLength As Integer = 4
	
	Dim SafeLength As Integer = Any
	
	' Посчитать размер буфера
	Scope
		
		Dim cbNeedenBufferLength As Integer = 0
		
		Dim i As Integer = 0
		Do While HtmlSafe[i] <> 0
			Dim Number As Integer = HtmlSafe[i]
			
			Select Case Number
				Case QuotationMarkChar
					cbNeedenBufferLength += MaxQuotationMarkSafeStringLength
					
				Case AmpersandChar
					cbNeedenBufferLength += MaxAmpersandSafeStringLength
					
				Case ApostropheChar
					cbNeedenBufferLength += MaxApostropheSafeStringLength
					
				Case LessThanSignChar
					cbNeedenBufferLength += MaxLessThanSignSafeStringLength
					
				Case GreaterThanSign
					cbNeedenBufferLength += MaxGreaterThanSignSafeStringLength
					
				Case Else
					cbNeedenBufferLength += 1
					
			End Select
			
			i += 1
		Loop
		SafeLength = i
		
		*pHtmlSafeLength = cbNeedenBufferLength
		
		If Buffer = 0 Then
			SetLastError(ERROR_SUCCESS)
			Return True
		End If
		
		If BufferLength < cbNeedenBufferLength Then
			SetLastError(ERROR_INSUFFICIENT_BUFFER)
			Return False
		End If
	End Scope
	
	Scope
		
		Dim BufferIndex As Integer = 0
		
		For OriginalIndex As Integer = 0 To SafeLength - 1
			Dim Number As Integer = HtmlSafe[OriginalIndex]
			
			Select Case Number
				Case Is < 32
					
				Case QuotationMarkChar
					' Заменить на &quot;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h71  ' q
					Buffer[BufferIndex + 2] = &h75  ' u
					Buffer[BufferIndex + 3] = &h6f  ' o
					Buffer[BufferIndex + 4] = &h74  ' t
					Buffer[BufferIndex + 5] = SemicolonChar  ' ;
					BufferIndex += MaxQuotationMarkSafeStringLength
					
				Case AmpersandChar
					' Заменить на &amp;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h61  ' a
					Buffer[BufferIndex + 2] = &h6d  ' m
					Buffer[BufferIndex + 3] = &h70  ' p
					Buffer[BufferIndex + 4] = SemicolonChar  ' ;
					BufferIndex += MaxAmpersandSafeStringLength
					
				Case ApostropheChar
					' Заменить на &apos;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h61  ' a
					Buffer[BufferIndex + 2] = &h70  ' p
					Buffer[BufferIndex + 3] = &h6f  ' o
					Buffer[BufferIndex + 4] = &h73  ' s
					Buffer[BufferIndex + 5] = SemicolonChar  ' ;
					BufferIndex += MaxApostropheSafeStringLength
					
				Case LessThanSignChar
					' Заменить на &lt;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h6c  ' l
					Buffer[BufferIndex + 2] = &h74  ' t
					Buffer[BufferIndex + 3] = SemicolonChar  ' ;
					BufferIndex += MaxLessThanSignSafeStringLength
					
				Case GreaterThanSign
					' Заменить на &gt;
					Buffer[BufferIndex + 0] = AmpersandChar    ' &
					Buffer[BufferIndex + 1] = &h67  ' g
					Buffer[BufferIndex + 2] = &h74  ' t
					Buffer[BufferIndex + 3] = SemicolonChar  ' ;
					BufferIndex += MaxGreaterThanSignSafeStringLength
					
				Case Else
					Buffer[BufferIndex] = Number
					BufferIndex += 1
					
			End Select
			
		Next
		
		' Завершающий нулевой символ
		Buffer[BufferIndex] = 0
		SetLastError(ERROR_SUCCESS)
		Return True
	End Scope
End Function

Function OpenOrCreateLog( _
		ByVal FileName As WString Ptr _
	)As Handle
	
	Dim hFile As Handle = CreateFile(FileName, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		Dim liDistanceToMove As LARGE_INTEGER = Any
		liDistanceToMove.QuadPart = -17
		SetFilePointerEx(hFile, liDistanceToMove, 0, FILE_END)
	Else
		hFile = CreateFile(FileName, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL)
		If hFile <> INVALID_HANDLE_VALUE Then
			Dim NumberOfBytesWritten As DWORD = Any
			Dim Utf8 As ZString * 4096 = Any
			Utf8[0] = 239
			Utf8[1] = 187
			Utf8[2] = 191
			WriteFile(hFile, @Utf8, 3, @NumberOfBytesWritten, 0)
			
			Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @XmlStart, -1, @Utf8, 4096 - 1, 0, 0) - 1
			WriteFile(hFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		End If
		' hFile = INVALID_HANDLE_VALUE
	End If
	Return hFile
End Function

Sub CloseXmlLog(ByVal hFile As Handle)
	Dim NumberOfBytesWritten As DWORD = Any
	Dim Utf8 As ZString * 4096 = Any
	
	Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @XmlEnd, -1, @Utf8, 4096 - 1, 0, 0) - 1
	WriteFile(hFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
	CloseHandle(hFile)
End Sub

Sub LogIrcMessage( _
		ByVal pBot As IrcBot Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim hLogFile As Handle = OpenOrCreateLog(@pBot->ChannelLogsFileName)
	If hLogFile <> INVALID_HANDLE_VALUE Then
		' <privmsgEntry httpDate="дата">
			' <channel></channel>
			' <nick></nick>
			' <message></message>
		' </privmsgEntry>
		
		Dim HttpDate As WString * (MaxHttpDateBufferLength + 1) = Any
		GetHttpDate(@HttpDate)
		
		Dim ChannelSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim ChannelSafeLength As Integer = Any
		GetHtmlSafeString(ChannelSafe, IrcClient.MaxBytesCount * 6, Channel, @ChannelSafeLength)
		
		Dim UserNameSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim UserNameSafeLength As Integer = Any
		GetHtmlSafeString(UserNameSafe, IrcClient.MaxBytesCount * 6, UserName, @UserNameSafeLength)
		
		Dim MessageTextSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim MessageTextSafeLength As Integer = Any
		GetHtmlSafeString(MessageTextSafe, IrcClient.MaxBytesCount * 6, MessageText, @MessageTextSafeLength)
		
		Dim ResultXml As WString * (IrcClient.MaxBytesCount * 20 + 1) = Any
		lstrcpy(@ResultXml, "<privmsgEntry httpDate=""")
		lstrcat(@ResultXml, @HttpDate)
		lstrcat(@ResultXml, @"""><channel>")
		lstrcat(@ResultXml, @ChannelSafe)
		lstrcat(@ResultXml, @"</channel><nick>")
		lstrcat(@ResultXml, @UserNameSafe)
		lstrcat(@ResultXml, @"</nick><message>")
		lstrcat(@ResultXml, @MessageTextSafe)
		lstrcat(@ResultXml, @"</message></privmsgEntry>")
		
		Dim NumberOfBytesWritten As DWORD = Any
		Dim Utf8 As ZString * (IrcClient.MaxBytesCount * 40 + 1) = Any
		
		Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @ResultXml, -1, @Utf8, IrcClient.MaxBytesCount * 40, 0, 0) - 1
		WriteFile(hLogFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		
		CloseXmlLog(hLogFile)
	End If
End Sub

Sub LogUserJoined( _
		ByVal pBot As IrcBot Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr _
	)
	
	Dim hLogFile As Handle = OpenOrCreateLog(@pBot->ChannelLogsFileName)
	If hLogFile <> INVALID_HANDLE_VALUE Then
		' <joinEntry httpDate="дата">
			' <channel></channel>
			' <nick></nick>
		' </joinEntry>
		
		Dim HttpDate As WString * (MaxHttpDateBufferLength + 1) = Any
		GetHttpDate(@HttpDate)
		
		Dim ChannelSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim ChannelSafeLength As Integer = Any
		GetHtmlSafeString(ChannelSafe, IrcClient.MaxBytesCount * 6, Channel, @ChannelSafeLength)
		
		Dim UserNameSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim UserNameSafeLength As Integer = Any
		GetHtmlSafeString(UserNameSafe, IrcClient.MaxBytesCount * 6, UserName, @UserNameSafeLength)
		
		Dim ResultXml As WString * (IrcClient.MaxBytesCount * 20 + 1) = Any
		lstrcpy(@ResultXml, "<joinEntry httpDate=""")
		lstrcat(@ResultXml, @HttpDate)
		lstrcat(@ResultXml, @"""><channel>")
		lstrcat(@ResultXml, @ChannelSafe)
		lstrcat(@ResultXml, @"</channel><nick>")
		lstrcat(@ResultXml, @UserNameSafe)
		lstrcat(@ResultXml, @"</nick></joinEntry>")
		
		Dim NumberOfBytesWritten As DWORD = Any
		Dim Utf8 As ZString * (IrcClient.MaxBytesCount * 40 + 1) = Any
		
		Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @ResultXml, -1, @Utf8, IrcClient.MaxBytesCount * 40, 0, 0) - 1
		WriteFile(hLogFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		
		CloseXmlLog(hLogFile)
	End If
End Sub

Sub LogUserQuit( _
		ByVal pBot As IrcBot Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim hLogFile As Handle = OpenOrCreateLog(@pBot->ChannelLogsFileName)
	If hLogFile <> INVALID_HANDLE_VALUE Then
		' <quitEntry httpDate="дата">
			' <nick></nick>
			' <message></message>
		' </quitEntry>
		
		Dim HttpDate As WString * (MaxHttpDateBufferLength + 1) = Any
		GetHttpDate(@HttpDate)
		
		Dim UserNameSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim UserNameSafeLength As Integer = Any
		GetHtmlSafeString(UserNameSafe, IrcClient.MaxBytesCount * 6, UserName, @UserNameSafeLength)
		
		Dim MessageTextSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim MessageTextSafeLength As Integer = Any
		GetHtmlSafeString(MessageTextSafe, IrcClient.MaxBytesCount * 6, MessageText, @MessageTextSafeLength)
		
		Dim ResultXml As WString * (IrcClient.MaxBytesCount * 20 + 1) = Any
		lstrcpy(@ResultXml, "<quitEntry httpDate=""")
		lstrcat(@ResultXml, @HttpDate)
		lstrcat(@ResultXml, @"""><nick>")
		lstrcat(@ResultXml, @UserNameSafe)
		lstrcat(@ResultXml, @"</nick><message>")
		lstrcat(@ResultXml, @MessageTextSafe)
		lstrcat(@ResultXml, @"</message></quitEntry>")
		
		Dim NumberOfBytesWritten As DWORD = Any
		Dim Utf8 As ZString * (IrcClient.MaxBytesCount * 40 + 1) = Any
		
		Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @ResultXml, -1, @Utf8, IrcClient.MaxBytesCount * 40, 0, 0) - 1
		WriteFile(hLogFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		
		CloseXmlLog(hLogFile)
	End If
End Sub

Sub LogPartChannel( _
		ByVal pBot As IrcBot Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)
	Dim hLogFile As Handle = OpenOrCreateLog(@pBot->ChannelLogsFileName)
	If hLogFile <> INVALID_HANDLE_VALUE Then
		' <partEntry httpDate="дата">
			' <channel></channel>
			' <nick></nick>
			' <message></message>
		' </partEntry>
		
		Dim HttpDate As WString * (MaxHttpDateBufferLength + 1) = Any
		GetHttpDate(@HttpDate)
		
		Dim ChannelSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim ChannelSafeLength As Integer = Any
		GetHtmlSafeString(ChannelSafe, IrcClient.MaxBytesCount * 6, Channel, @ChannelSafeLength)
		
		Dim UserNameSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim UserNameSafeLength As Integer = Any
		GetHtmlSafeString(UserNameSafe, IrcClient.MaxBytesCount * 6, UserName, @UserNameSafeLength)
		
		Dim MessageTextSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim MessageTextSafeLength As Integer = Any
		GetHtmlSafeString(MessageTextSafe, IrcClient.MaxBytesCount * 6, MessageText, @MessageTextSafeLength)
		
		Dim ResultXml As WString * (IrcClient.MaxBytesCount * 20 + 1) = Any
		lstrcpy(@ResultXml, "<partEntry httpDate=""")
		lstrcat(@ResultXml, @HttpDate)
		lstrcat(@ResultXml, @"""><channel>")
		lstrcat(@ResultXml, @ChannelSafe)
		lstrcat(@ResultXml, @"</channel><nick>")
		lstrcat(@ResultXml, @UserNameSafe)
		lstrcat(@ResultXml, @"</nick><message>")
		lstrcat(@ResultXml, @MessageTextSafe)
		lstrcat(@ResultXml, @"</message></partEntry>")
		
		Dim NumberOfBytesWritten As DWORD = Any
		Dim Utf8 As ZString * (IrcClient.MaxBytesCount * 40 + 1) = Any
		
		Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @ResultXml, -1, @Utf8, IrcClient.MaxBytesCount * 40, 0, 0) - 1
		WriteFile(hLogFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		
		CloseXmlLog(hLogFile)
	End If
End Sub

Sub LogNickChanged( _
		ByVal pBot As IrcBot Ptr, _
		ByVal OldNick As WString Ptr, _
		ByVal NewNick As WString Ptr _
	)
	Dim hLogFile As Handle = OpenOrCreateLog(@pBot->ChannelLogsFileName)
	If hLogFile <> INVALID_HANDLE_VALUE Then
		' <nickEntry httpDate="дата">
			' <oldNick></oldNick>
			' <newNick></newNick>
		' </nickEntry>
		
		Dim HttpDate As WString * (MaxHttpDateBufferLength + 1) = Any
		GetHttpDate(@HttpDate)
		
		Dim OldNickSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim OldNickSafeLength As Integer = Any
		GetHtmlSafeString(OldNickSafe, IrcClient.MaxBytesCount * 6, OldNick, @OldNickSafeLength)
		
		Dim NewNickSafe As WString * (IrcClient.MaxBytesCount * 6 + 1) = Any
		Dim NewNickSafeLength As Integer = Any
		GetHtmlSafeString(NewNickSafe, IrcClient.MaxBytesCount * 6, NewNick, @NewNickSafeLength)
		
		Dim ResultXml As WString * (IrcClient.MaxBytesCount * 20 + 1) = Any
		lstrcpy(@ResultXml, "<nickEntry httpDate=""")
		lstrcat(@ResultXml, @HttpDate)
		lstrcat(@ResultXml, @"""><oldNick>")
		lstrcat(@ResultXml, @OldNickSafe)
		lstrcat(@ResultXml, @"</oldNick><newNick>")
		lstrcat(@ResultXml, @NewNickSafe)
		lstrcat(@ResultXml, @"</newNick></nickEntry>")
		
		Dim NumberOfBytesWritten As DWORD = Any
		Dim Utf8 As ZString * (IrcClient.MaxBytesCount * 40 + 1) = Any
		
		Dim Utf8Length As Integer = WideCharToMultiByte(CP_UTF8, 0, @ResultXml, -1, @Utf8, IrcClient.MaxBytesCount * 40, 0, 0) - 1
		WriteFile(hLogFile, @Utf8, Utf8Length, @NumberOfBytesWritten, 0)
		
		CloseXmlLog(hLogFile)
	End If
End Sub

Sub LogTopic( _
		ByVal pBot As IrcBot Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TopicText As WString Ptr _
	)
End Sub

Sub LogKick( _
		ByVal pBot As IrcBot Ptr, _
		ByVal AdminName As WString Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal KickedUser As WString Ptr _
	)
End Sub
