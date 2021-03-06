#include "DccSendServer.bi"
#include "Network.bi"
#include "IntegerToWString.bi"
#include "win\Mswsock.bi"

'Const SendDccFilePort = "6699"
'RJE (Remote Job Entry) — обслуживает отправку файлов и вывод отчётов при работе рабочей станции с мейнфреймами
Const SendDccFilePort = "5"
Const OneMinetesInMilliseconds As DWORD = 60 * 1000

Sub DccSendFileToClient( _
		ByVal pBot As IrcBot Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal LocalAddress As WString Ptr, _
		ByVal FileFullPath As WString Ptr, _
		ByVal ClientFileName As WString Ptr _
	)
	Dim zAddress As ZString * 256
	WideCharToMultiByte(CP_ACP, 0, LocalAddress, -1, @zAddress, 255, 0, NULL)
	
	Dim IpAddress As ULong = htonl(inet_addr(@zAddress))
	Dim wAddress As WString * 256
	i64tow(IpAddress, @wAddress, 10)
	
	Dim hFile As HANDLE = CreateFile(FileFullPath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL Or FILE_FLAG_SEQUENTIAL_SCAN, NULL)
	
	If hFile <> INVALID_HANDLE_VALUE Then
		Dim FileSize As LARGE_INTEGER = Any
		Dim GetFileSizeExResult As Integer = GetFileSizeEx(hFile, @FileSize)
		
		SendDccSend(@pBot->Client, UserName, ClientFileName, @wAddress, @SendDccFilePort, FileSize.QuadPart)
		
		Dim ServerEvent As WSAEVENT = WSACreateEvent()
		
		If ServerEvent <> WSA_INVALID_EVENT Then
			Dim ServerSocket As SOCKET = CreateSocketAndBind(LocalAddress, @SendDccFilePort)
			
			If ServerSocket <> INVALID_SOCKET Then
				
				If WSAEventSelect(ServerSocket, ServerEvent, FD_ACCEPT Or FD_CLOSE) <> SOCKET_ERROR Then
					
					If listen(ServerSocket, 1) <> SOCKET_ERROR Then
						Dim RemoteAddress As SOCKADDR_IN = Any
						Dim RemoteAddressLength As Long = SizeOf(RemoteAddress)
						Dim ClientSocket As SOCKET = accept(ServerSocket, CPtr(SOCKADDR Ptr, @RemoteAddress), @RemoteAddressLength)
						Dim WSAErrorResult As Integer = WSAGetLastError()
						
						If ClientSocket = INVALID_SOCKET Then
							
							If WSAErrorResult = WSAEWOULDBLOCK Then
								Dim EventIndex As DWORD = WSAWaitForMultipleEvents(1, @ServerEvent, False, OneMinetesInMilliseconds, False)
								
								Select Case EventIndex
									Case WSA_WAIT_FAILED
										
									Case WSA_WAIT_IO_COMPLETION
										
									Case WSA_WAIT_TIMEOUT
										
									Case WSA_WAIT_EVENT_0
										Dim NetworkEvents As WSANETWORKEVENTS = Any
										WSAEnumNetworkEvents(ServerSocket, ServerEvent, @NetworkEvents)
										
										Select Case NetworkEvents.lNetworkEvents
											Case FD_CLOSE
												
											Case FD_ACCEPT
												ClientSocket = accept(ServerSocket, CPtr(SOCKADDR Ptr, @RemoteAddress), @RemoteAddressLength)
												
										End Select
										
									End Select
									
							End If
							
						End If
						
						If ClientSocket <> INVALID_SOCKET Then
							TransmitFile(ClientSocket, hFile, 0, 0, NULL, NULL, 0)
							CloseSocketConnection(ClientSocket)
						End If
						
					End If
				End If
				
				closesocket(ServerSocket)
			End If
			
			WSACloseEvent(ServerEvent)
		End If
		
		CloseHandle(hFile)
	End If
	
End Sub
