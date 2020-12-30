module Season
  def self.christmas?
    (Date.today.month == 12 && Date.today.day < 25) || Date.today.month == 11
  end
end
