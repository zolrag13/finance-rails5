module Financials
  class Projection < Hash
    include Calculator::Compounding

    def initialize(ki)
      @ki = ki
    end

    def project(current_price)
      this_year = @ki.current_year
      min_per, max_per = [this_year['price_earnings_ratio_5y_avg'], this_year['price_earnings_ratio_10y_avg']].minmax
      worst_per, best_per = [this_year['price_earnings_ratio_10y_min'], this_year['price_earnings_ratio_10y_max']]
      self['projected_eps'] = future_val(this_year['eps_basic'], this_year['eps_basic_10y_annual_rate_of_return'], 5)
      self['projected_price_worst'] = self['projected_eps'] * worst_per
      self['projected_price_min'] = self['projected_eps'] * min_per
      self['projected_price_max'] = self['projected_eps'] * max_per
      self['projected_price_best'] = self['projected_eps'] * best_per
      self['projected_rate_of_return_worst'] = annual_rate_of_return(current_price, self['projected_price_worst'], 5)
      self['projected_rate_of_return_min'] = annual_rate_of_return(current_price, self['projected_price_min'], 5)
      self['projected_rate_of_return_max'] = annual_rate_of_return(current_price, self['projected_price_max'], 5)
      self['projected_rate_of_return_best'] = annual_rate_of_return(current_price, self['projected_price_best'], 5)
      target_rate = 0.15
      self['max_price'] = present_val(self['projected_eps'], target_rate, 5) * this_year['price_earnings_ratio']
    end

  end

end

