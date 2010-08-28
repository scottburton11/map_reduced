class String
  def underscore
    self.scan(/[A-Z][a-z0-9]*/).map(&:downcase).join("_")
  end
end