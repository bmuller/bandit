class Array
  alias_method :sample, :choice unless method_defined?(:sample)
end