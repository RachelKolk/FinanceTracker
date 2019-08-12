class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    begin
        client = IEX::Api::Client.new(publishable_token: 'pk_9ed33d1688b244358bcbfdc5d0d68ac8')
        looked_up_stock = client.quote(ticker_symbol)
        price = strip_commas(look_up_stock.l)
        new(name: looked_up_stock.name,
            ticker: looked_up_stock.symbol, last_price: price)
    rescue Exception => e
        return nil
    end
  end

  def self.strip_commas
    number.gsub(",", "")
  end

end
