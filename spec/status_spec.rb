require 'spec_helper'
require 'quick_travel/cache'
require 'quick_travel/status'

describe QuickTravel::Status do
  specify {
    expect { QuickTravel::Status.check! }.to_not raise_error
  }
end
