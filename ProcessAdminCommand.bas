#include once "ProcessAdminCommand.bi"
#include once "BotCommands.bi"
#include once "DateTimeToString.bi"
#include once "IntegerToWString.bi"
#include once "CharConstants.bi"
#include once "Settings.bi"
#include once "AnswerToChat.bi"

' Константы команд
Const AllAdminCommands = "справка покажи жуйк . статистика кто з пенис ник зайди выйди сгинь тема скажи ну пароль делай"

Const CommandDone = "Команда выполнена"

Function ProcessAdminCommand( _
		ByVal pBot As IrcBot Ptr, _
		ByVal User As WString Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As Boolean
	
	' Разбить текст по пробелам
	Dim WordsCount As Long = Any
	Dim Lines As WString Ptr Ptr = CommandLineToArgvW(MessageText, @WordsCount)
	
	' Выход из сети !сгинь причина выхода из сети
	If lstrcmp(Lines[0], @QuitCommand) = 0 Then
		If WordsCount > 1 Then
			Dim w As WString Ptr = StrChr(MessageText, WhiteSpaceChar)
			pBot->Client.QuitFromServer(@w[1])
		Else
			Dim strQuitString As WString * SizeOf(WString)
			pBot->Client.QuitFromServer(@strQuitString)
		End If
		LocalFree(Lines)
		Return True
	End If
	
	' Смена ника !ник новый ник
	If lstrcmp(Lines[0], @NickCommand) = 0 Then
		pBot->Client.ChangeNick(Lines[1])
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Присоединение к каналу !зайди channel
	If lstrcmp(Lines[0], @JoinCommand) = 0 Then
		pBot->Client.JoinChannel(Lines[1])
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Отключение от канала !выйди channel причина выхода
	If lstrcmp(Lines[0], @PartCommand) = 0 Then
		If WordsCount > 2 Then
			Dim w As WString Ptr = StrChr((StrChr(MessageText, WhiteSpaceChar))[1], WhiteSpaceChar)
			pBot->Client.PartChannel(Lines[1], @w[1])
		Else
			Dim strQuitString As WString * SizeOf(WString)
			pBot->Client.PartChannel(Lines[1], @strQuitString)
		End If
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Смена темы канала !тема канал новая тема канала
	If lstrcmp(Lines[0], @TopicCommand) = 0 Then
		If WordsCount > 2 Then
			Dim w As WString Ptr = StrChr((StrChr(MessageText, WhiteSpaceChar))[1], WhiteSpaceChar)
			pBot->Client.ChangeTopic(Lines[1], @w[1])
		Else
			' Очистить тему
		End If
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Сырое сообщение !ну текст
	If lstrcmp(Lines[0], @RawCommand) = 0 Then
		If WordsCount > 1 Then
			Dim w As WString Ptr = StrChr(MessageText, WhiteSpaceChar)
			pBot->Client.SendRawMessage(@w[1])
			pBot->Say(Channel, @CommandDone)
		End If
		LocalFree(Lines)
		Return True
	End If
	
	' Установить пароль на никсерв !пароль текст
	If lstrcmp(Lines[0], @PasswordCommand) = 0 Then
		If WordsCount > 1 Then
			Dim w As WString Ptr = StrChr(MessageText, WhiteSpaceChar)
			If SetSettingsValue(@PasswordKey, w) Then
				pBot->Say(Channel, @CommandDone)
			End If
		End If
		LocalFree(Lines)
		Return True
	End If
	
	' Сказать в чат !скажи канал текст сообщения
	If lstrcmp(Lines[0], @SayCommand) = 0 Then
		If WordsCount > 2 Then
			Dim w As WString Ptr = StrChr((StrChr(MessageText, WhiteSpaceChar))[1], WhiteSpaceChar)
			pBot->Say(Lines[1], @w[1])
			pBot->Say(Channel, @CommandDone)
		End If
		LocalFree(Lines)
		Return True
	End If
	
	' Показать список ключевых фраз !вопросы
	If lstrcmp(MessageText, @QuestionListCommand) = 0 Then
		GetQuestionList(pBot, Channel)
		LocalFree(Lines)
		Return True
	End If
	
	' Добавить ключевую фразу !вопрос фраза
	If lstrcmp(Lines[0], @AddQuestionCommand) = 0 Then
		If WordsCount > 1 Then
			Dim w As WString Ptr = StrChr(MessageText, WhiteSpaceChar)
			AddQuestion(pBot, Channel, @w[1])
		End If
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Добавить ответ !ответ номер‐вопроса фраза
	If lstrcmp(Lines[0], @AddAnswerCommand) = 0 Then
		If WordsCount > 2 Then
			Dim w As WString Ptr = StrChr((StrChr(MessageText, WhiteSpaceChar))[1], WhiteSpaceChar)
			AddAnswer(pBot, Channel, wtoi(Lines[1]), @w[1])
		End If
		pBot->Say(Channel, @CommandDone)
		LocalFree(Lines)
		Return True
	End If
	
	' Показать список ответов !ответы номер‐ответа фраза
	If lstrcmp(Lines[0], @AnswerListCommand) = 0 Then
		If WordsCount > 1 Then
			GetAnswerList(pBot, Channel, wtoi(Lines[1]))
		End If
		LocalFree(Lines)
		Return True
	End If
	
	LocalFree(Lines)
	Return False
End Function
