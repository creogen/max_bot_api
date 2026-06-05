# Changelog

All notable changes to this project will be documented in this file.

## [0.3.0] - 2026-06-05

### Added

- `MessageBuilder#set_disable_link_preview` and message send support for the `disable_link_preview` query param.
- Chat pinning helpers:
  - `Resources::Chats#pin_message`
  - `Resources::Chats#get_pinned_message`
  - `Resources::Chats#unpin_message`
- `KeyboardRowBuilder#add_clipboard` for clipboard buttons.
- `Client::SECRET_HEADER` and `Client#webhook_secret_valid?` for webhook secret validation.
- Tests for chat pinning, clipboard buttons, message link preview control, and webhook secret validation.

### Changed

- Webhook examples and docs now mirror the upstream Go client flow: validate the secret header before parsing the payload.
- API coverage docs now mark chat pinning and `disable_link_preview` as supported.

### Breaking

- None.

## [0.2.0] - 2026-03-03

### Added

- `MessageBuilder#add_photo_by_token(token)`.
- `KeyboardRowBuilder#add_message(text)`.
- `ApiError#attachment_not_ready?`.
- Message format constants:
  - `MessageBuilder::FORMAT_HTML`
  - `MessageBuilder::FORMAT_MARKDOWN`

### Changed

- Default API host changed to `https://platform-api.max.ru/`.
- Message send and edit now retry on `attachment.not.ready` with exponential backoff.
- `get_messages` now encodes `message_ids` as a comma-separated string.
- Upload error handling is stricter.
- Error payload parsing better maps API `{ code, message }` responses into `ApiError`.

### Breaking

- Default base URL changed from `https://botapi.max.ru/` to `https://platform-api.max.ru/`.

See `BREAKING_CHANGES_0.1.0_to_0.2.0.md` for more detail.

## [0.1.0] - 2026-03-02

### Added

- Initial Ruby client release.
- Core resources:
  - Bots
  - Chats
  - Messages
  - Subscriptions
  - Uploads
  - Debugs
- Message and keyboard builders.
- Long polling update iteration.
- Webhook payload parsing.
- Upload helpers for files, photos, audio, and video.
