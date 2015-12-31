require 'test_helper'

class RobinhoodRailsTest < ActiveSupport::TestCase
  test "it works" do
    trader = Robinhood.new("nemrow", "Rlights11d")
    if trader.login
      byebug
    end
    byebug
    p ""
    #   account = trader.accounts
    #   byebug
      # account_num = '5QU31279'
      # trader = Robinhood.new
      # trader.get_token("nemrow", "Rlights11d")



      # stock = trader.instruments("LSG")['results'][0]
      # trader.buy(stock["symbol"], stock["url"], "0.84", 1) // this works
  end
end
