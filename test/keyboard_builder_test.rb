# frozen_string_literal: true

require 'test_helper'

class KeyboardBuilderTest < Minitest::Test
  def test_add_clipboard_builds_expected_button
    keyboard = MaxBotApi::Builders::KeyboardBuilder.new
    keyboard.add_row.add_clipboard('Copy docs', 'https://dev.max.ru/docs-api')

    assert_equal(
      {
        buttons: [
          [
            {
              type: 'clipboard',
              text: 'Copy docs',
              payload: 'https://dev.max.ru/docs-api'
            }
          ]
        ]
      },
      keyboard.build
    )
  end
end
