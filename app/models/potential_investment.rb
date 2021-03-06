class PotentialInvestment < ApplicationRecord

  belongs_to :company

  def self.latest(type = 'basic', year = Time.current.year)
    PotentialInvestment.where("latest AND selector = ? AND year = '?'", type, year)
  end

  def self.sorted_latest(type = 'basic')
    pis = PotentialInvestment.latest(type)
    current_year = Time.current.year
    too_young, ok = pis.partition(&:too_young?)
    good_pis, remaining = ok.partition(&:good?)
    bad_pis, not_so_good_pis = remaining.partition(&:bad?)

    [good_pis, not_so_good_pis, bad_pis, too_young].map do |arr|
      arr.sort_by do |pi|
        company = pi.company
        proj = company.projections.where("latest and year = '?'", current_year - 1).first
        [company.current_price / proj.projected_value_1y, -pi.eps_5y_annual_compounding_ror, -pi.roe_5y_annual_compounding_ror]
      end
    end.flatten
  end

  def too_young?
    n_past_financial_statements < 8
  end

  def good?
    return false if latest_projection.nil?
    latest_projection.projected_rate_of_return_min_1y > 15 && latest_projection.projected_rate_of_return_worst_1y > 0 &&
      company.current_price <= latest_projection.projected_value_1y
  end

  def bad?
    return true if latest_projection.nil?
    company.current_price > latest_projection.projected_value_1y
  end

  def not_so_good?
    return true if latest_projection.nil?
    latest_projection.projected_rate_of_return_worst_1y <= 0
  end

  def kfi
    company.latest_kfi.first
  end

  def projections
    current_year = Time.current.year
    @projections = company.projections.where("latest = true and year = '?'", current_year - 1)
  end

  def latest_projection
    current_year = Time.current.year
    projection(current_year - 1)
  end

  def projection(year)
    company.projections.where("latest = true AND year = ?", year.to_s).first || company.projections.where("latest = true").first
  end

  def price_earnings_ratio_10y_avg
    return 0.0 if kfi.nil?
    kfi.price_earnings_ratio_10y_avg
  end

  def price_earnings_ratio_5y_avg
    return 0.0 if kfi.nil?
    kfi.price_earnings_ratio_5y_avg
  end
  #
  # def roe_5y_annual_compounding_ror
  #   kfi.return_on_equity_5y_annual_rate_of_return
  # end
  #
  # def roe_10y_annual_compounding_ror
  #   kfi.return_on_equity_10y_annual_rate_of_return
  # end
  #
  # def eps_5y_annual_compounding_ror
  #   kfi.eps_basic_5y_annual_rate_of_return
  # end
  #
  # def eps_10y_annual_compounding_ror
  #   kfi.eps_basic_10y_annual_rate_of_return
  # end

  def eps_diluted
    return 0.0 if kfi.nil?
    kfi.eps_diluted
  end

  # def n_past_financial_statements
  #   kfi.n_past_financial_statements
  # end
end
