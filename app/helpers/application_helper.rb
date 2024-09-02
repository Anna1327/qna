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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
