require 'httparty'

class Robinhood
  include HTTParty

  attr_accessor :errors

  # >>> NOTES

  # When buying  and selling the request requires the account which is
  # actually the url of the account. node package claims it comes
  # with login, but it didn't, so you need to call the accounts endpint (just the first time)
  # and then take the account url and store it on the user for future transactions.

  # Everything else seems to be working alright. Just finish porting the node
  # version over to this gem, and then implement it into the app

  # <<< NOTES

  def initialize
  end

  def login(username, password)
    raw_response = HTTParty.post(
      endpoints[:login],
      body: {
        'password' => password,
        'username'=> username
      }.as_json,
      headers: headers
    )
    response = JSON.parse(raw_response.body)
    if response["non_field_errors"]
      puts response["non_field_errors"]
      false
    elsif response["token"]
      puts response['token']
    end
  end

  def investment_profile
    raw_response = HTTParty.get(endpoints[:investment_profile], headers: headers)
    JSON.parse(raw_response.body)
  end

  def orders
    raw_response = HTTParty.get(endpoints[:orders], headers: headers)
    JSON.parse(raw_response.body)
  end

  def accounts
    raw_response = HTTParty.get(endpoints[:accounts], headers: headers)
    JSON.parse(raw_response.body)
  end

  def instruments(symbol)
    raw_response = HTTParty.get(endpoints[:instruments], query: {'query' => symbol.upcase}, headers: headers)
    JSON.parse(raw_response.body)
  end

  def quote(symbol)
    raw_response = HTTParty.post("https://api.robinhood.com/quotes/#{symbol}/", headers: headers)
    JSON.parse(raw_response.body)
  end

  def buy(symbol, instrument_id, price, quantity)
    raw_response = HTTParty.post(
      endpoints[:orders],
      body: {
        'account' => "https://api.robinhood.com/accounts/#{ENV['ROBINHOOD_ACCOUNT_NUMBER']}/",
        'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
        'price' => price,
        'quantity' => quantity,
        'side' => "buy",
        'symbol' => symbol,
        'time_in_force' => 'gfd',
        'trigger' => 'immediate',
        'type' => 'market'
      }.as_json,
      headers: headers
    )
  end

  def limit_buy(symbol, instrument_id, price, quantity)
    raw_response = HTTParty.post(
      endpoints[:orders],
      body: {
        'account' => "https://api.robinhood.com/accounts/#{ENV['ROBINHOOD_ACCOUNT_NUMBER']}/",
        'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
        'price' => price,
        'quantity' => quantity,
        'side' => "buy",
        'symbol' => symbol,
        'time_in_force' => 'gfd',
        'trigger' => 'immediate',
        'type' => 'limit'
      }.as_json,
      headers: headers
    )
  end

  def sell(symbol, instrument_id, price, quantity)
    raw_response = HTTParty.post(
      endpoints[:orders],
      body: {
        'account' => "https://api.robinhood.com/accounts/#{ENV['ROBINHOOD_ACCOUNT_NUMBER']}/",
        'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
        'price' => price,
        'quantity' => quantity,
        'side' => "sell",
        'symbol' => symbol,
        'time_in_force' => 'gfd',
        'trigger' => 'immediate',
        'type' => 'market'
      }.as_json,
      headers: headers
    )
  end

  def limit_sell(symbol, instrument_id, price, quantity)
    raw_response = HTTParty.post(
      endpoints[:orders],
      body: {
        'account' => "https://api.robinhood.com/accounts/#{ENV['ROBINHOOD_ACCOUNT_NUMBER']}/",
        'instrument' => "https://api.robinhood.com/instruments/#{instrument_id}/",
        'price' => price,
        'quantity' => quantity,
        'side' => "sell",
        'symbol' => symbol,
        'time_in_force' => 'gfd',
        'trigger' => 'immediate',
        'type' => 'limit'
      }.as_json,
      headers: headers
    )
  end

  def cancel_order(order_id)
    raw_response = HTTParty.post("https://api.robinhood.com/orders/#{order_id}/cancel/", headers: headers)
    raw_response.code == 200
  end

  private

  def endpoints
    {
      login:  'https://api.robinhood.com/api-token-auth/',
      investment_profile: 'https://api.robinhood.com/user/investment_profile/',
      accounts: 'https://api.robinhood.com/accounts/',
      ach_iav_auth: 'https://api.robinhood.com/ach/iav/auth/',
      ach_relationships:  'https://api.robinhood.com/ach/relationships/',
      ach_transfers:'https://api.robinhood.com/ach/transfers/',
      applications: 'https://api.robinhood.com/applications/',
      dividends:  'https://api.robinhood.com/dividends/',
      edocuments: 'https://api.robinhood.com/documents/',
      instruments:  'https://api.robinhood.com/instruments/',
      margin_upgrade:  'https://api.robinhood.com/margin/upgrades/',
      markets:  'https://api.robinhood.com/markets/',
      notifications:  'https://api.robinhood.com/notifications/',
      orders: 'https://api.robinhood.com/orders/',
      password_reset: 'https://api.robinhood.com/password_reset/request/',
      quotes: 'https://api.robinhood.com/quotes/',
      document_requests:  'https://api.robinhood.com/upload/document_requests/',
      user: 'https://api.robinhood.com/user/',
      watchlists: 'https://api.robinhood.com/watchlists/'
    }
  end

  def headers
    @headers ||= {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip, deflate',
      'Accept-Language' => 'en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8',
      'X-Robinhood-API-Version' => '1.0.0',
      'Connection' => 'keep-alive',
      'User-Agent' => 'Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)',
      "Authorization" => "Token #{ENV["ROBINHOOD_SECRET_TOKEN"]}"
    }
  end
end
