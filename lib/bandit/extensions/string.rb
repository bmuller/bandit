class String
  def numeric?
    true if Integer(self) rescue false
  end
end
