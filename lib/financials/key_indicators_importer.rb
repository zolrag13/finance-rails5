module Financials

  class KeyIndicatorsImporter

    def initialize(companies = nil)
      @companies = companies || Company.active
    end

    def import
      @companies.each_with_index do |company, index|
        puts "(#{index}/#{@companies.size}) Generating KFI for company #{company.name}"
        kib = KeyIndicatorsBuilder.new(company)
        ki = kib.build
        ActiveRecord::Base.transaction do
          company.latest_key_financial_indicators.update_all(:latest => false)
          save(ki, company)
        end
      end
    end

    def save(ki, company)
      ki.all_years(Time.current.year - 10).each do |year|
        this_year = ki.per_year[year]
        KeyFinancialIndicator.create({
          :company_id => company.id,
          :debt_to_equity => this_year['debt_to_equity'],
          :return_on_equity => this_year['return_on_equity'],
          :return_on_assets => this_year['return_on_assets'],
          :eps_basic => this_year['eps_basic'],
          :free_cash_flow => this_year['free_cash_flow'],
          :current_ratio => this_year['current_ratio'],
          :net_margin => this_year['net_margin'],
          :debt_to_equity_yoy_growth => this_year['debt_to_equity_yoy_growth'],
          :return_on_equity_yoy_growth => this_year['return_on_equity_yoy_growth'],
          :return_on_assets_yoy_growth => this_year['return_on_assets_yoy_growth'],
          :eps_basic_yoy_growth => this_year['eps_basic_yoy_growth'],
          :free_cash_flow_yoy_growth => this_year['free_cash_flow_yoy_growth'],
          :current_ratio_yoy_growth => this_year['current_ratio_yoy_growth'],
          :net_margin_yoy_growth => this_year['net_margin_yoy_growth'],
          :return_on_equity_5y_annual_rate_of_return => this_year['return_on_equity_5y_annual_rate_of_return'],
          :return_on_assets_5y_annual_rate_of_return => this_year['return_on_assets_5y_annual_rate_of_return'],
          :eps_basic_5y_annual_rate_of_return => this_year['eps_basic_5y_annual_rate_of_return'],
          :debt_to_equity_5y_avg => this_year['debt_to_equity_5y_avg'],
          :free_cash_flow_5y_avg => this_year['free_cash_flow_5y_avg'],
          :current_ratio_5y_avg => this_year['current_ratio_5y_avg'],
          :net_margin_5y_avg => this_year['net_margin_5y_avg'],
          :return_on_equity_10y_annual_rate_of_return => this_year['return_on_equity_10y_annual_rate_of_return'],
          :return_on_assets_10y_annual_rate_of_return => this_year['return_on_assets_10y_annual_rate_of_return'],
          :eps_basic_10y_annual_rate_of_return => this_year['eps_basic_10y_annual_rate_of_return'],
          :debt_to_equity_10y_avg => this_year['debt_to_equity_10y_avg'],
          :free_cash_flow_10y_avg => this_year['free_cash_flow_10y_avg'],
          :current_ratio_10y_avg => this_year['current_ratio_10y_avg'],
          :net_margin_10y_avg  => this_year['net_margin_10y_avg '],
          :n_past_financial_statements => ki.n_past_financial_statements,
          :year => year,
          :latest => true
        })
      end
    end

  end

end