class ErrorSerializer
  include JSONAPI::Serializer
  def self.serialize(errors)
    if errors.is_a?(String)
      { errors: [{ detail: errors }] }
    else
      errors_hash = errors.full_messages.join(', ')
      { errors: [{ detail: errors_hash }] }
    end
  end
end