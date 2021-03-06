#include "ProcessGetLogsCommand.bi"
#include "DccSendServer.bi"

Const LogFileString = "ChannelLogs.xml"
Const IrcBotSendChannelLogsMapFileName = "IrcBotSendChannelLogs"

Type StatisticWordCountParam
	Dim pBot As IrcBot Ptr
	Dim UserName As WString * (IrcClient.MaxBytesCount + 1)
	Dim Channel As WString * (IrcClient.MaxBytesCount + 1)
	Dim hMapFile As HANDLE
End Type

Function ChannelLogThread(ByVal lpParam As LPVOID)As DWORD
	Dim ttp As StatisticWordCountParam Ptr = CPtr(StatisticWordCountParam Ptr, lpParam)
	
	DccSendFileToClient(ttp->pBot, @ttp->UserName, @ttp->pBot->LocalAddress, @ttp->pBot->ChannelLogsFileName, @LogFileString)
	
	Dim hMapFile As Handle = ttp->hMapFile
	UnmapViewOfFile(ttp)
	CloseHandle(hMapFile)
	Return 0
End Function

Sub ProcessGetLogsCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr _
	)
	
	Dim hMapFile As Handle = CreateFileMapping(INVALID_HANDLE_VALUE, 0, PAGE_READWRITE, 0, SizeOf(StatisticWordCountParam), @IrcBotSendChannelLogsMapFileName)
	If hMapFile <> NULL Then
		
		If GetLastError() <> ERROR_ALREADY_EXISTS Then
			
			Dim ttp As StatisticWordCountParam Ptr = CPtr(StatisticWordCountParam Ptr, MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(StatisticWordCountParam)))
			If ttp <> 0 Then
				ttp->hMapFile = hMapFile
				ttp->pBot = pBot
				lstrcpy(ttp->UserName, User)
				lstrcpy(ttp->Channel, Channel)
				
				Dim hThread As Handle = CreateThread(NULL, 0, @ChannelLogThread, ttp, 0, 0)
				If hThread <> NULL Then
					CloseHandle(hThread)
				Else
					UnmapViewOfFile(ttp)
					CloseHandle(hMapFile)
					pBot->Say(Channel, @"Не могу создать поток получения истории")
				End If
			Else
				CloseHandle(hMapFile)
				pBot->Say(Channel, @"Не могу выделить память")
			End If
		Else
			CloseHandle(hMapFile)
		End If
	Else
		pBot->Say(Channel, @"Не могу создать отображение файла")
	End If
End Sub
