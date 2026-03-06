# Объекты API

Источник: https://dev.max.ru/docs-api

Всего объектов: 126

| Объект | Краткое описание |
| --- | --- |
| `ActionRequestBody` |  |
| `Attachment` | Общая схема, представляющая вложение сообщения |
| `AttachmentPayload` |  |
| `AttachmentRequest` | Запрос на прикрепление данных к сообщению |
| `AudioAttachment` |  |
| `AudioAttachmentRequest` | Запрос на прикрепление аудио к сообщению. ДОЛЖЕН быть единственным вложением в сообщении |
| `BotAddedToChatUpdate` | Вы получите этот update, как только бот будет добавлен в чат |
| `BotCommand` | до 32 элементов<br/>Команды, поддерживаемые ботом |
| `BotInfo` | Объект включает общую информацию о боте, URL аватара и описание. Дополнительно содержит список команд, поддерживаемых… |
| `BotPatch` |  |
| `BotRemovedFromChatUpdate` | Вы получите этот update, как только бот будет удалён из чата |
| `BotStartedUpdate` | Бот получает этот тип обновления, как только пользователь нажал кнопку `Start` |
| `BotStoppedUpdate` | Бот получает этот тип обновления, как только пользователь останавливает бота |
| `Button` |  |
| `Callback` | Объект, отправленный боту, когда пользователь нажимает кнопку |
| `CallbackAnswer` | Отправьте этот объект, когда ваш бот хочет отреагировать на нажатие кнопки |
| `CallbackButton` | После нажатия на такую кнопку клиент отправляет на сервер полезную нагрузку, которая содержит |
| `Chat` |  |
| `ChatAdmin` |  |
| `ChatAdminPermission` | Права администратора чата |
| `ChatAdminsList` |  |
| `ChatButton` | Кнопка, которая создает новый чат, как только первый пользователь на нее нажмёт. Бот будет добавлен в участники чата… |
| `ChatList` |  |
| `ChatMember` | Объект включает общую информацию о пользователе или боте, URL аватара и описание (при наличии). Дополнительно содержит… |
| `ChatMembersList` |  |
| `ChatPatch` |  |
| `ChatStatus` | Статус чата для текущего бота |
| `ChatTitleChangedUpdate` | Бот получит это обновление, когда будет изменено название чата |
| `ChatType` | Тип чата: диалог, чат |
| `ContactAttachment` |  |
| `ContactAttachmentPayload` |  |
| `ContactAttachmentRequest` | Запрос на прикрепление карточки контакта к сообщению. ДОЛЖЕН быть единственным вложением в сообщении |
| `ContactAttachmentRequestPayload` |  |
| `DataAttachment` | Attachment contains payload sent through `SendMessageButton` |
| `DialogClearedUpdate` | Бот получает этот тип обновления сразу после очистки истории диалога. |
| `DialogMutedUpdate` | Вы получите этот update, когда пользователь заглушит диалог с ботом |
| `DialogRemovedUpdate` | Вы получите этот update, когда пользователь удаляет чат |
| `DialogUnmutedUpdate` | Вы получите этот update, когда пользователь включит уведомления в диалоге с ботом |
| `EmphasizedMarkup` | Представляет *курсив* |
| `Error` | Сервер возвращает это, если возникло исключение при вашем запросе |
| `FailedUserDetails` | Подробное описание, почему пользователь не был добавлен в чат |
| `FileAttachment` |  |
| `FileAttachmentPayload` |  |
| `FileAttachmentRequest` | Запрос на прикрепление файла к сообщению. ДОЛЖЕН быть единственным вложением в сообщении |
| `GetPinnedMessageResult` |  |
| `GetSubscriptionsResult` | Список всех WebHook подписок |
| `HeadingMarkup` | Представляет заголовок текста |
| `HighlightedMarkup` | Представляет выделенную часть текста |
| `Image` | Общая схема, описывающая объект изображения |
| `InlineKeyboardAttachment` | Кнопки в сообщении |
| `InlineKeyboardAttachmentRequest` | Запрос на прикрепление клавиатуры к сообщению |
| `InlineKeyboardAttachmentRequestPayload` |  |
| `Intent` | Намерение кнопки |
| `Keyboard` | Клавиатура - это двумерный массив кнопок |
| `LinkButton` | После нажатия на такую кнопку пользователь переходит по ссылке, которую она содержит |
| `LinkMarkup` | Представляет ссылку в тексте |
| `LinkedMessage` |  |
| `LocationAttachment` |  |
| `LocationAttachmentRequest` | Запрос на прикрепление клавиатуры к сообщению |
| `MarkupElement` |  |
| `MediaAttachmentPayload` |  |
| `Message` | Сообщение в чате |
| `MessageBody` | Схема, представляющая тело сообщения |
| `MessageButton` | Кнопка для запуска мини-приложения |
| `MessageCallbackUpdate` | Вы получите этот `update` как только пользователь нажмёт кнопку |
| `MessageChatCreatedUpdate` | Бот получит это обновление, когда чат будет создан, как только первый пользователь нажмёт кнопку чата |
| `MessageCreatedUpdate` | ы получите этот `update`, как только сообщение будет создано |
| `MessageEditedUpdate` | Вы получите этот `update`, как только сообщение будет отредактировано |
| `MessageLinkType` | Тип связанного сообщения |
| `MessageList` | Пагинированный список сообщений |
| `MessageRemovedUpdate` | Вы получите этот `update`, как только сообщение будет удалено |
| `MessageStat` | Статистика сообщения |
| `ModifyMembersResult` | � езультат запроса на изменение списка участников |
| `MonospacedMarkup` | Представляет `моноширинный` или блок ```код``` в тексте |
| `NewMessageBody` |  |
| `NewMessageLink` |  |
| `OpenAppButton` | Кнопка для запуска мини-приложения |
| `PhotoAttachment` | Вложение изображения |
| `PhotoAttachmentPayload` |  |
| `PhotoAttachmentRequest` |  |
| `PhotoAttachmentRequestPayload` | Запрос на прикрепление изображения (все поля являются взаимоисключающими) |
| `PhotoToken` |  |
| `PhotoTokens` | Это информация, которую вы получите, как только изображение будет загружено |
| `PinMessageBody` |  |
| `Recipient` | Новый получатель сообщения. Может быть пользователем или чатом |
| `ReplyButton` | After pressing this type of button client will send a message on behalf of user with given payload |
| `ReplyKeyboardAttachment` | Custom reply keyboard in message |
| `ReplyKeyboardAttachmentRequest` | Request to attach reply keyboard to message |
| `RequestContactButton` | AПосле нажатия на такую кнопку клиент отправляет новое сообщение с вложением текущего контакта пользователя |
| `RequestGeoLocationButton` | После нажатия на такую кнопку клиент отправляет новое сообщение с вложением текущего географического положения… |
| `SendContactButton` | AПосле нажатия на такую кнопку клиент отправляет новое сообщение с вложением текущего контакта пользователя |
| `SendGeoLocationButton` | После нажатия на такую кнопку клиент отправляет новое сообщение с вложением текущего географического положения… |
| `SendMessageButton` | After pressing this type of button client will send a message on behalf of user with given payload |
| `SendMessageResult` |  |
| `SenderAction` | Действие, отправляемое участникам чата. Возможные значения: - `"typing_on"` — Бот набирает сообщение. -… |
| `ShareAttachment` |  |
| `ShareAttachmentPayload` | Полезная нагрузка запроса ShareAttachmentRequest |
| `ShareAttachmentRequest` | Запрос на прикрепление предпросмотра медиафайла по внешнему URL |
| `SimpleQueryResult` | Простой ответ на запрос |
| `StickerAttachment` |  |
| `StickerAttachmentPayload` |  |
| `StickerAttachmentRequest` | Запрос на прикрепление стикера. ДОЛЖЕН быть единственным вложением в сообщении |
| `StickerAttachmentRequestPayload` |  |
| `StrikethroughMarkup` | Представляет ~зачекрнутый~ текст |
| `StrongMarkup` | Представляет **жирный** текст |
| `Subscription` | Схема для описания подписки на WebHook |
| `SubscriptionRequestBody` | Запрос на настройку подписки WebHook |
| `TextFormat` | Формат текста сообщения |
| `UnderlineMarkup` | Представляет <ins>подчеркнутый</ins> текст |
| `Update` | Объект`Update` представляет различные типы событий, произошедших в чате. См. его наследников > Чтобы получать события… |
| `UpdateList` | Список всех обновлений в чатах, в которых ваш бот участвовал |
| `UploadEndpoint` | Точка доступа, куда следует загружать ваши бинарные файлы |
| `UploadType` | Тип загружаемого файла Поддерживаемые форматы: - `image`: JPG, JPEG, PNG, GIF, TIFF, BMP, HEIC - `video`: MP4, MOV,… |
| `UploadedInfo` | Это информация, которую вы получите, как только аудио/видео будет загружено |
| `User` | Объект, описывающий один из вариантов наследования: - [`User`](/docs-api/objects/User) — объект содержит общую… |
| `UserAddedToChatUpdate` | Вы получите это обновление, когда пользователь будет добавлен в чат, где бот является администратором |
| `UserIdsList` |  |
| `UserMentionMarkup` | Представляет упоминание пользователя в тексте. Упоминание может быть как по имени пользователя, так и по ID, если у… |
| `UserRemovedFromChatUpdate` | Вы получите это обновление, когда пользователь будет удалён из чата, где бот является администратором |
| `UserWithPhoto` | Объект с общей информацией о пользователе или боте, дополнительно содержит URL аватара и описание |
| `VideoAttachment` |  |
| `VideoAttachmentDetails` |  |
| `VideoAttachmentRequest` | Запрос на прикрепление видео к сообщению |
| `VideoThumbnail` |  |
| `VideoUrls` |  |
| `bigint` |  |