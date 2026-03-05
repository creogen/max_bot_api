# Breaking changes: 0.1.0 -> 0.2.0

This document lists breaking or potentially breaking changes introduced in 0.2.0.

## Breaking

- Default base URL changed to `https://platform-api.max.ru/`.
  - Previous default: `https://botapi.max.ru/`.
  - If your environment still requires the legacy host, pass `base_url:` explicitly:

```ruby
client = MaxBotApi::Client.new(token: ENV.fetch('MAX_TOKEN'), base_url: 'https://botapi.max.ru/')
```

## Potentially breaking / behavior changes

- Error payload parsing now maps `{ code, message }` to `ApiError#message` and `ApiError#details`.
  - If you compared error messages directly, the string may differ.
  - The attachment retry logic relies on `ApiError#message == "attachment.not.ready"`.

- Message send/edit now retries on `attachment.not.ready` with exponential backoff.
  - This can increase request duration for media-heavy flows.
  - Retries are capped by `Client::MAX_RETRIES`.

- `get_messages` encodes `message_ids` as a comma-separated string.
  - If you relied on repeated `message_ids[]` parameters, update accordingly.

- Uploads error handling is stricter.
  - Non-2xx upload responses now raise `ApiError` when possible.
  - For audio/video uploads, the returned token comes from the `/uploads` endpoint response.

## Additions (non-breaking)

- `MessageBuilder#add_photo_by_token(token)`.
- `KeyboardRowBuilder#add_message(text)`.
- `ApiError#attachment_not_ready?`.
- Message format constants: `MessageBuilder::FORMAT_HTML`, `MessageBuilder::FORMAT_MARKDOWN`.

## Notes

- Update payloads may now include new update types and fields:
  - `bot_stopped`, `dialog_removed`, `dialog_cleared`.
  - `bot_started.payload`.
  - `message_removed.chat_id`, `message_removed.user_id`.
  - `user.name`.
