require 'quick_travel/adapter'
require 'quick_travel/credit_card'

module QuickTravel
  class Checkout < Adapter
    # Provides the url to redirect the browser to when payment
    # is via an external gateway
    attr_reader :redirect_url

    # Slow checkouts will require a poll -- use #status(checkout_id)
    attr_reader :requires_poll, :progress

    attr_reader :error

    def self.client_token(data)
      get_and_validate('/api/checkouts/client_token.json', data).symbolize_keys
    end

    # Create a checkout in QuickTravel
    def self.create(data)
      build_checkout_for { post_and_validate('/api/checkouts.json', data) }
    end

    # Poll for status of checkout
    #
    # While in progress returns:
    #   progress: 'processing'
    #
    # When complete:
    #   progress: 'completed'
    #
    # When failed, status :ok
    #   successful: false
    #   error: 'Reason for failure'
    def self.status(id)
      build_checkout_for { get_and_validate("/api/checkouts/#{id}.json?v=1") }
    end

    def self.update(id, data)
      build_checkout_for { put_and_validate("/api/checkouts/#{id}.json", data) }
    end

    def self.build_checkout_for(&block)
      new(attributes_for(&block))
    end

    # TODO Move to an external builder?
    def self.attributes_for
      attrs = yield
      attrs[:completed] = attrs['progress'] == 'completed'
      attrs[:successful] = attrs[:completed]
      attrs
    rescue AdapterError => e
      {
        completed:  true,
        successful: false,
        error:      e.message
      }
    end

    def id
      @checkout_id # This is the key QT returns
    end

    # These methods are a bit ewwwwy...
    # We really have a tri-state: FAILED, SUCCEEDED, PROCESSING
    #
    # ...in process of fixing up users of this class
    def completed?
      @completed
    end

    # Successful OR processing... OMG.. :(
    def successful?
      @successful
    end

    def unsuccessful?
      completed? && !successful?
    end

    def to_h
      {
        checkout_id:   id,
        progress:      progress,
        completed:     completed?,
        successful:    successful?,
        requires_poll: requires_poll,
        redirect_url:  redirect_url,
        error:         error
      }
    end
  end
end
