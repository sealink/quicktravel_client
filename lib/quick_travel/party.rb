module QuickTravel
  class Party < Adapter
    LOGIN_URL = '/api/login.json'

    attr_reader :phone, :mobile, :email   # if has a contact
    attr_reader :post_code, :country_id   # if has an address

    def initialize(hash = {})
      super
      # TODO Fix the QT endpoint to actual return the type, first step
      # is to revert it so we can fix the pacts, than we can update the
      # expectations to include a return value
      @type = 'Person'
    end

    self.api_base = '/parties'

    def self.find_by_login(options)
      get_and_validate('/parties/find_by_login.json', options)
    end

    def self.create(options = {})
      post_and_validate("/api/parties.json", options)
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
