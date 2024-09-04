# frozen_string_literal: true

module ApplicationHelper
  FLASH_TO_CSS = {
    notice: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    success: 'alert-success'
  }.freeze

  def flash_to_css(key)
    FLASH_TO_CSS.fetch(key.to_sym, key)
  end
end
