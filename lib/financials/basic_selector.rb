module Financials

  class BasicSelector < PotentialInvestmentSelector
    SELECTOR = 'basic'
    ROE_MIN = 12
    EPS_MIN = 15
    FREE_CASH_FLOW_MIN = 0
    CURRENT_RATIO_MIN = 1
    POSITIVE_GROWTH_PERCENTAGE = 0.8
    STEADY_GROWTH_N_YEARS = 9
    CONSTANT_VALUE_PERCENTAGE = 0.8
    POSITIVE_CRITERIA_PERCENTAGE = 0.9

    def initialize(companies = nil)
      @companies = companies || active_companies
      @roe_min = ROE_MIN
      @eps_min = EPS_MIN
      @positive_growth_percentage = POSITIVE_GROWTH_PERCENTAGE
      @selector = SELECTOR
      @steady_growth_n_years = STEADY_GROWTH_N_YEARS
      @positive_constant_value_percentage = CONSTANT_VALUE_PERCENTAGE
      @free_cash_flow_min = FREE_CASH_FLOW_MIN
      @current_ratio_min = CURRENT_RATIO_MIN
      @prev_records = PotentialInvestment.latest
      @positive_criteria_percentage = POSITIVE_CRITERIA_PERCENTAGE
    end

    def single_year_criteria
      {
          'return_on_equity_5y_annual_rate_of_return' => lambda { |roe| roe_criteria(roe) },
          'return_on_equity_10y_annual_rate_of_return' => lambda { |roe| roe_criteria(roe) },
          'eps_diluted_5y_annual_rate_of_return' => lambda { |eps| eps_criteria(eps) },
          'eps_diluted_10y_annual_rate_of_return' => lambda { |eps| eps_criteria(eps) },
      }
    end

    def multi_year_criteria
      {
          'ROE_steady_growth' => lambda { |ki| roe_growth_criteria(ki) },
          'EPS_steady_growth' => lambda { |ki| eps_growth_criteria(ki) },
          'EPS_positive' => lambda { |ki| eps_min_criteria(ki) },
          'FCF_positive' => lambda { |ki| free_cash_flow_growth_criteria(ki) },
          'Current_ratio_positive' => lambda { |ki| current_ratio_criteria(ki) }
      }
    end

  end

end
