#include once "AnswerToChat.bi"
#include once "IntegerToWString.bi"
#include once "Settings.bi"

' Таблица ключевых фраз и ответов
Type QuestionAnswer
	' Ключевая фраза
	Dim Question As WString * 512
	' Количество ответов
	Dim AnswersCount As Integer
	' Список из 50 ответов
	Dim Answers(49) As WString * 512
End Type

Sub AnswerToChat(ByVal pBot As IrcBot Ptr, ByVal User As WString Ptr, ByVal MessageText As WString Ptr)
	Dim hFile As HANDLE = CreateFile(@pBot->AnswersDatabaseFileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		' Вопрос‐ответ
		Dim qa As QuestionAnswer = Any
		Dim BytesCount As DWORD = Any
		Dim result As Integer = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		
		Do While result <> 0
			If BytesCount <> SizeOf(QuestionAnswer) Then
				Exit Do
			End If
			' Найти ключевую фразу
			If StrStrI(MessageText, qa.Question) <> 0 Then
				' Получить ответ
				If qa.AnswersCount > 0 Then
					' Отправить пользователю случайную
					Dim AnswerIndex As Integer = pBot->ReceivedRawMessagesCounter Mod qa.AnswersCount
					pBot->Say(User, @qa.Answers(AnswerIndex))
				End If
				Exit Do
			End If
			result = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Loop
		
		CloseHandle(hFile)
	End If
End Sub

Sub GetQuestionList(ByVal pBot As IrcBot Ptr, ByVal User As WString Ptr)
	Dim hFile As HANDLE = CreateFile(@pBot->AnswersDatabaseFileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		' Вопрос‐ответ
		Dim qa As QuestionAnswer = Any
		Dim BytesCount As DWORD = Any
		Dim result As Integer = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Dim QuestionCount As Integer = 0
		
		Do While result <> 0
			If BytesCount <> SizeOf(QuestionAnswer) Then
				Exit Do
			End If
			If lstrlen(qa.Question) = 0 Then
				Exit Do
			End If
			
			Dim buf As WString * 100 = Any
			itow(QuestionCount, @buf, 10)
			
			pBot->Say(User, @buf)
			pBot->Say(User, @qa.Question)
			
			SleepEx(MessageTimeWait, 0)
			
			QuestionCount += 1
			result = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Loop
		
		CloseHandle(hFile)
	End If
End Sub

Sub GetAnswerList(ByVal pBot As IrcBot Ptr, ByVal User As WString Ptr, ByVal QuestionIndex As Integer)
	Dim hFile As HANDLE = CreateFile(@pBot->AnswersDatabaseFileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		' Вопрос‐ответ
		Dim qa As QuestionAnswer = Any
		Dim BytesCount As DWORD = Any
		Dim result As Integer = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Dim QuestionCount As Integer = 0
		
		Do While result <> 0
			If BytesCount <> SizeOf(QuestionAnswer) Then
				Exit Do
			End If
			' Найти ключевую фразу
			If lstrlen(qa.Question) = 0 Then
				Exit Do
			End If
			If QuestionIndex = QuestionCount Then
				
				Scope
					Dim buf As WString * 100 = Any
					lstrcpy(@buf, @"Фраза ")
					itow(QuestionCount, @buf + lstrlen(@buf), 10)
					
					pBot->Say(User, @buf)
					pBot->Say(User, @qa.Question)
					
					SleepEx(MessageTimeWait, 0)
				End Scope
				
				For i As Integer = 0 To qa.AnswersCount - 1
					Dim buf As WString * 100 = Any
					lstrcpy(@buf, @"Ответ ")
					itow(i, @buf + lstrlen(@buf), 10)
					
					pBot->Say(User, @buf)
					pBot->Say(User, @qa.Answers(i))
					
					SleepEx(MessageTimeWait, 0)
				Next
				
				Exit Do
			End If
			QuestionCount += 1
			result = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Loop
		
		CloseHandle(hFile)
	End If
End Sub

Sub AddQuestion(ByVal pBot As IrcBot Ptr, ByVal User As WString Ptr, ByVal Question As WString Ptr)
	Dim hFile As HANDLE = CreateFile(@pBot->AnswersDatabaseFileName, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		SetFilePointer(hFile, 0, NULL, FILE_END)
		' Вопрос‐ответ
		Dim qa As QuestionAnswer = Any
		memset(@qa, 0, SizeOf(QuestionAnswer))
		
		lstrcpy(@qa.Question, Question)
		
		Dim BytesCount As DWORD = Any
		Dim result As Integer = WriteFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		
		CloseHandle(hFile)
	End If
End Sub

Sub AddAnswer(ByVal pBot As IrcBot Ptr, ByVal User As WString Ptr, ByVal QuestionIndex As Integer, ByVal Answer As WString Ptr)
	Dim hFile As HANDLE = CreateFile(@pBot->AnswersDatabaseFileName, GENERIC_READ + GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL)
	If hFile <> INVALID_HANDLE_VALUE Then
		Dim qa As QuestionAnswer = Any
		Dim BytesCount As DWORD = Any
		Dim result As Integer = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Dim QuestionCount As Integer = 0
		
		Do While result <> 0
			If BytesCount <> SizeOf(QuestionAnswer) Then
				Exit Do
			End If
			' Найти ключевую фразу
			If lstrlen(qa.Question) = 0 Then
				Exit Do
			End If
			If QuestionIndex = QuestionCount Then
				lstrcpy(@qa.Answers(qa.AnswersCount), Answer)
				qa.AnswersCount += 1
				
				SetFilePointer(hFile, -SizeOf(QuestionAnswer), NULL, FILE_CURRENT)
				result = WriteFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
				
				Exit Do
			End If
			QuestionCount += 1
			result = ReadFile(hFile, @qa, SizeOf(QuestionAnswer), @BytesCount, 0)
		Loop
		
		CloseHandle(hFile)
	End If
End Sub
