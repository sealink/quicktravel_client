module QuickTravel
  class CreditCard
    def self.type_from_number(number)
      case number.to_s
      when /^4.*$/ then 'visa'
      when /^5[1-5].*$/ then 'master'
      when /^3[4,7].*$/ then 'american_express'
      when /^3[0,6,8].*$/ then 'diners_club'
      end
    end
  end
end
