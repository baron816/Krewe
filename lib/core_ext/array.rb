class Array
  def positive_count
    new_count = self.count
    new_count > 0 ? new_count : nil
  end
end
