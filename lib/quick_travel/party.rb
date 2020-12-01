module QuickTravel
  class Party < Adapter
    LOGIN_URL = '/api/login.json'

    attr_reader :phone, :mobile, :email   # if has a contact
    attr_reader :post_code, :country_id   # if has an address

    def initialize(hash = {})
      super
      if type.blank?
        @type = 'Person'
      end
    end

    self.api_base = '/api/parties'

    def self.find_by_login(options)
      get_and_validate('/parties/find_by_login.json', options)
    end

    # Asks QuickTravel to check the credentials
    #
    # @returns: Party: Valid Credentials
    #          Nil: Invalid Credentialss
    def self.login(options = { login: nil, password: nil })
      unless options[:login] && options[:password]
        fail ArgumentError, 'You must specify :login and :password'
      end
      response = post_and_validate(LOGIN_URL, options)
      Party.new(response) unless response[:error]
    end

    def self.request_password(login, url)
      options = { login: login, url: url }
      post_and_validate('/api/sessions/request_password_reset', options)
    end

    def self.set_password_via_token(token, password)
      post_and_validate('/api/sessions/set_password_via_token', token: token, password: password)
    rescue QuickTravel::AdapterError => e
      { error: e.message }
    end
  end
end
