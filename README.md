# Бот для IRC‐каналов

Написан на фрибейсике. Можно скомпилировать как обычное консольное приложение и как службу Windows. Изначально разрабатывается для каналов #freebasic-ru и #s2ch, в настоящее время можно использовать для любых каналов и сетей.

## Команды доступные пользователю


### Показать список команд

```
!справка
```

Псевдонимы: `!help`, `!помощь`.


### Показать статистику пользователей

```
!статистика
```

Бот отправит файл с количеством сказанных фраз всех пользователей текущего канала.


### Текст в виде забора

```
!з <текст>
```

Бот отправит текст «в ВиДе ЗаБоРа» для издевательства над другими пользователями.


### Пинг пользователя

Достаточно отправиь в чат точку:

```
.
```

Бот ответит какова задержка сообщений между тобой и ботом в микросекундах.


### Посоветовать что‐либо из двух вариантов

Полный вариант:

```
Чат, скажи: <а> или <б>?
```

Сокращённый вариант:

```
Чат, <а> или <б>?
```

В ответ бот отправит один из вариантов с рекомендацией.


### Отправить фразу на жуйк

```
!жуйк <фраза>
```

В ответ бот скажет, что отправит на жуйкочан (на самом деле нет).


### Установить таймер

```
!таймер <время в секундах> <текст сообщения>
```

Бот установит таймер на определённое число секунд, после чего скажет в чату фразу.


### Показать ASCII графику

```
!покажи <рисунок>
```

В ответ бот отправит один из рисунков. Фраза должна быть в родительном падеже. Доступные рисунки:

* синего кита
* дом с трубой
* сову
* котэ с рыбой
* стоящего котэ


### Проверка аутентификации

```
!кто
```

Бот отправит сообщение «WHOIS ник» на сервер и проверит аутентификацию. Бот не сообщает результат прохождения аутентификации.


### Измерить длину пениса

```
!пенис [ник]
```

Бот отправит в чат длину пениса пользователя.

### Создание уникального идентификатора

```
!guid
```

Бот создаст уникальный идентификатор типа GUID и отправит результат в чат.


## Команды доступные администратору


### Выход из сети

```
!сгинь [причина выхода]
```


### Сменить ник

```
!ник <новый ник>
```


### Зайти на канал

```
!зайди <канал>
```


### Покинуть канал

```
!выйди <канал> [причина]
```


### Сменить тему

```
!тема <новая тема>
```


### Сказать в чат

```
!скажи <кому> <что>
```


### Сказать сырую команду

```
!ну <текст>
```

### Выполнить на сервере файл

```
!делай <исполняемый файл> <параметры>
```


### Установить пароль для NickServ

```
!пароль <пароль>
```

### Добавить ключевую фразу для реагирования

```
!вопрос <фраза>
```


### Добавить ответ

```
!ответ <номер вопроса> <фраза>
```


### Показать список ключевых фраз

```
!вопросы
```


### Показать список ответов

```
!ответы <номер вопроса>
```

## Конфигурация бота

Настройки бота лежат в файле `Qubick.ini` рядом с исполняемым файлом. Файл настроек считывается единожды при запуске программы. Примерный вариант файла настроек:

```
[Connection]
Server=chat.freenode.net
Port=6667
LocalAddress=0.0.0.0
LocalPort=0

[IrcBot]
ServerPassword=
Nick=Qubick
UserString=Qubick
RealName=John Doe
Description=Irc bot written in FreeBASIC

Channels=#freebasic-ru,#s2ch
MainChannel=#freebasic-ru

AdminNick1=writed
AdminNick2=PERDOLIKS
```


#### Описание раздела Connection

<dl>
<dt>Server</dt>
<dd>Доменное имя сервера или IP‐адрес.</dd>
</dl>

<dl>
<dt>Port</dt>
<dd>Порт для соединения с сервером.</dd>
</dl>

<dl>
<dt>LocalAddress</dt>
<dd>IP‐адрес сетевой карты, с которой будет идти соединение с сервером.</dd>
</dl>

<dl>
<dt>LocalPort</dt>
<dd>Локальный порт для соединения с сервером, по умолчанию 0.</dd>
</dl>


#### Описание раздела IrcBot

<dl>
<dt>ServerPassword</dt>
<dd>Пароль на сервер, часто не требуется.</dd>
</dl>

<dl>
<dt>Nick</dt>
<dd>Имя бота.</dd>
</dl>

<dl>
<dt>UserString</dt>
<dd>USER‐строка.</dd>
</dl>

<dl>
<dt>RealName</dt>
<dd>Настоящее имя владельца бота.</dd>
</dl>

<dl>
<dt>Description</dt>
<dd>Описание бота.</dd>
</dl>

<dl>
<dt>Channels</dt>
<dd>Список каналов, на которых будет сидеть бот. Каналы разделяются запятыми без пробелов.</dd>
</dl>

<dl>
<dt>MainChannel</dt>
<dd>Главный канал, на нмё будет запрашиваться информация о версии входящих пользователей.</dd>
</dl>

<dl>
<dt>AdminNick1</dt>
<dd>Главный ник и учётная запись администратора. К этому нику можно привязать запасной.</dd>
</dl>

<dl>
<dt>AdminNick2</dt>
<dd>Запасной ник администратора.</dd>
</dl>


## Компиляция

Для компиляции потребуется статическая библиотека `libIRC`, взять её можно отсюда https://github.com/BatchedFiles/IrcClientLibrary

Обычное приложение:

```
fbc -i "C:\Programming\FreeBASIC Projects\IrcClientLibrary\trunk" -l IRC -l Mswsock Main.bas Bot.bas MainLoop.bas BotEvents.bas BotCommands.bas ProcessCommands.bas ProcessCreateGuidCommand.bas ProcessCtcpPingCommand.bas ProcessFenceCommand.bas ProcessGetLogsCommand.bas ProcessHelpCommand.bas ProcessAsciiGraphicsCommand.bas ProcessChooseFromTwoOptionsCommand.bas ProcessChannelStatisticsCommand.bas ProcessUserWhoIsCommand.bas ProcessTimerCommand.bas ProcessPenisCommand.bas ProcessExecuteCommand.bas Logging.bas AnswerToChat.bas QuestionToChat.bas WriteLine.bas DateTimeToString.bas Settings.bas StringFunctions.bas DccSendServer.bas Network.bas
```

Служба Windows:

```
fbc -d service=true -i "C:\Programming\FreeBASIC Projects\IrcClientLibrary\trunk" -l IRC -l Mswsock Service.bas Bot.bas MainLoop.bas BotEvents.bas BotCommands.bas ProcessCommands.bas ProcessCreateGuidCommand.bas ProcessCtcpPingCommand.bas ProcessFenceCommand.bas ProcessGetLogsCommand.bas ProcessHelpCommand.bas ProcessAsciiGraphicsCommand.bas ProcessChooseFromTwoOptionsCommand.bas ProcessChannelStatisticsCommand.bas ProcessUserWhoIsCommand.bas ProcessTimerCommand.bas ProcessPenisCommand.bas ProcessExecuteCommand.bas Logging.bas AnswerToChat.bas QuestionToChat.bas WriteLine.bas DateTimeToString.bas Settings.bas StringFunctions.bas DccSendServer.bas Network.bas
```
