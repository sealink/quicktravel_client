class Price
  attr_accessor :cents, :currency, :dollars

  def initialize(hash)
    cents = hash['cents'].to_i
    @dollars = cents / 100
    @cents = cents % 100
    @currency = hash['currency']
  end

  def formatted_text
    "#{@dollars}"
  end
end
