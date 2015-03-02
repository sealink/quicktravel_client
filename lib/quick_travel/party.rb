module QuickTravel
  class Party < Adapter
    LOGIN_URL = '/login.json'

    attr_accessor :id, :type, :name, :login, :title, :first_name, :last_name, :gender, :active, :internal_staff, :display_name

    attr_accessor :client_id, :vendor_id
    attr_accessor :surchargeable
    attr_accessor :client_type_id, :client_type_name, :client_type_is_agent
    attr_accessor :default_web_user, :rights

    attr_accessor :phone, :mobile, :email   # if has a contact
    attr_accessor :post_code, :country_id   # if has an address

    def initialize(hash = {})
      super
      if type.blank?
        self.type = 'Person'
      end
    end

    self.api_base = '/parties'

    def self.find_by_login(options)
      get_and_validate('/parties/find_by_login.json', options)
    end

    # Asks QuickTravel to check the credentials
    #
    # @returns: Party: Valid Credentials
    #          Nil: Invalid Credentialss
    def self.login(options = { login: nil, password: nil })
      fail 'You must specify :login and :password' unless options[:login] && options[:password]
      response = post_and_validate(LOGIN_URL, options)
      Party.new(response) unless response[:error]
    end

    def self.request_password(login, url)
      options = { login: login, url: url }
      post_and_validate('/sessions/request_password_reset', options)
    end

    def self.set_password_via_token(token, password)
      post_and_validate('/sessions/set_password_via_token', token: token, password: password)
    rescue QuickTravel::AdapterException => e
      { error: e.message }
    end
  end
end
