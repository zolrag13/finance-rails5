module Importer

  class StockRowStatementImporter < StatementImporter

    INCOME_STAT_MAPPING = {
        'Revenues' => :revenues,
        'Revenue' => :revenues,
        'Revenue Growth' => :revenue_growth,
        'Cost of Revenue' => :cost_of_revenue,
        'Gross Profit' => :gross_profit,
        'Selling, General and Administrative Expense' => :selling_general_and_administrative_expense,
        'SG&A Expense' => :selling_general_and_administrative_expense,
        'Research and Development Expense' => :research_and_development_expense,
        'R&D Expenses' => :research_and_development_expense,
        'Earning Before Interest & Taxes (EBIT)' => :ebit,
        'EBIT' => :ebit,
        'Interest Expense' => :interest_expense,
        'Income Tax Expense' => :income_tax_expense,
        'Net Income' => :net_income,
        'Net Income Common Stock' => :net_income_common_stock,
        'Net Income Com' => :net_income_common_stock,
        'Preferred Dividends Income Statement Impact' => :preferred_dividends_income_statement_impact,
        'Preferred Dividends' => :preferred_dividends_income_statement_impact,
        'Earnings per Basic Share' => :eps_basic,
        'EPS' => :eps_basic,
        'Earnings per Diluted Share' => :eps_diluted,
        'EPS Diluted' => :eps_diluted,
        'Weighted Average Shares' => :weighted_avg_shares,
        'Weighted Average Shares Diluted' => :weighted_avg_shares_diluted,
        'Weighted Average Shs Out' => :weighted_avg_shares,
        'Dividends per Basic Common Share' => :dividends_per_basic_common_share,
        'Dividend per Share' => :dividends_per_basic_common_share,
        'Net Income from Discontinued Operations' => :net_income_discontinued_operations,
        'Gross Margin' => :gross_margin,
        'Revenues (USD)' => :revenues_usd,
        'Earning Before Interest & Taxes (USD)' => :ebit_usd,
        'Net Income Common Stock (USD)' => :net_income_common_stock_usd,
        'Earnings per Basic Share (USD)' => :eps_basic_usd,
        'Operating Expenses' => :operating_expenses,
        'Operating Income' => :operating_income,
        'Earnings before Tax' => :earnings_before_tax,
        'Net Income to Non-Controlling Interests' => :net_income_to_non_controlling_interests,
        'Earnings Before Interest, Taxes & Depreciation Amortization (EBITDA)' => :ebitda,
        'EBITDA' => :ebitda,
        'EBITDA Margin' => :ebitda_margin,
        'EBIT Margin' => :ebit_margin,
        'Profit Margin' => :profit_margin,
        'Free Cash Flow Margin' => :free_cash_flow_margin,
        'FCF Margin' => :free_cash_flow_margin,
        'Consolidated Income' => :consolidated_income
    }

    BALANCE_SHEET_MAPPING = {
        'Cash and Equivalents' => :cash_and_equivalents,
        'Cash and cash equivalents' => :cash_and_equivalents,
        'Trade and Non-Trade Receivables' => :trade_and_non_trade_receivables,
        'Receivables' => :trade_and_non_trade_receivables,
        'Inventory' => :inventory,
        'Inventories' => :inventory,
        'Current Assets' => :current_assets,
        'Total current assets' => :current_assets,
        'Goodwill and Intangible Assets' => :goodwill_and_intangible_assets,
        'Assets Non-Current' => :assets_non_current,
        'Total non-current assets' => :assets_non_current,
        'Total Assets' => :total_assets,
        'Total assets' => :total_assets,
        'Trade and Non-Trade Payables' => :trade_and_non_trade_payables,
        'Payables' => :trade_and_non_trade_payables,
        'Current Liabilities' => :current_liabilities,
        'Total current liabilities' => :current_liabilities,
        'Total Debt' => :total_debt,
        'Total debt' => :total_debt,
        'Liabilities Non-Current' => :liabilities_non_current,
        'Total non-current liabilities' => :liabilities_non_current,
        'Total Liabilities' => :total_liabilities,
        'Accumulated Other Comprehensive Income' => :accumulated_other_comprehensive_income,
        'Other comprehensive income' => :accumulated_other_comprehensive_income,
        'Accumulated Retained Earnings (Deficit)' => :accumulated_retained_earnings_deficit,
        'Retained earnings (deficit)' => :accumulated_retained_earnings_deficit,
        'Shareholders Equity' => :shareholders_equity,
        'Shareholders Equity (USD)' => :shareholders_equity_usd,
        'Total Debt (USD)' => :total_debt_usd,
        'Cash and Equivalents (USD)' => :cash_and_equivalents_usd,
        'Investments Current' => :investments_current,
        'Short-term investments' => :investments_current,
        'Investments Non-Current' => :investments_non_current,
        'Long-term investments' => :investments_non_current,
        'Property, Plant & Equipment Net' => :property_plant_and_equipment_net,
        'Tax Assets' => :tax_assets,
        'Tax assets' => :tax_assets,
        'Debt Current' => :debt_current,
        'Short-term debt' => :debt_current,
        'Debt Non-Current' => :debt_non_current,
        'Long-term debt' => :debt_non_current,
        'Tax Liabilities' => :tax_liabilities,
        'Deferred Revenue' => :deferred_revenue,
        'Deferred revenue' => :deferred_revenue,
        'Deposit Liabilities' => :deposit_liabilities,
        'Investments' => :investments,
        'Cash and Short Term Investments' => :cash_and_short_term_investments,
        'Cash and short-term investments' => :cash_and_short_term_investments
    }

    CASH_FLOW_STAT_MAPPING = {
        'Depreciation, Amortization & Accretion' => :depreciation_amortization_accretion,
        'Depreciation & Amortization' => :depreciation_amortization_accretion,
        'Net Cash Flow from Operations' => :net_cash_flow_from_operations,
        'Operating Cash Flow' => :net_cash_flow_from_operations,
        'Operating CF' => :net_cash_flow_from_operations,
        'Capital Expenditure' => :capital_expenditure,
        'Net Cash Flow from Investing' => :net_cash_flow_from_investing,
        'Investment purchases and sales' => :net_cash_flow_from_investing,
        'Investing Cash Flow' => :net_cash_flow_from_investing,
        'Investing CF' => :net_cash_flow_from_investing,
        'Issuance (Repayment) of Debt Securities' => :issuance_repayment_of_debt_securities,
        'Issuance (repayment) of debt' => :issuance_repayment_of_debt_securities,
        'Issuance (Purchase) of Equity Shares' => :issuance_purchase_of_equity_shares,
        'Issuance (buybacks) of shares' => :issuance_purchase_of_equity_shares,
        'Payment of Dividends & Other Cash Distributions' => :payment_of_dividends_and_other_cash_distributions,
        'Dividend payments' => :payment_of_dividends_and_other_cash_distributions,
        'Net Cash Flow from Financing' => :net_cash_flow_from_financing,
        'Financing Cash Flow' => :net_cash_flow_from_financing,
        'Financing CF' => :net_cash_flow_from_financing,
        'Effect of Exchange Rate Changes on Cash' => :effect_of_exchange_rate_changes_on_cash,
        'Effect of forex changes on cash' => :effect_of_exchange_rate_changes_on_cash,
        'Net Cash Flow / Change in Cash & Cash Equivalents' => :net_cash_flow_change_in_cash_and_cash_equivalents,
        'Net cash flow / Change in cash' => :net_cash_flow_change_in_cash_and_cash_equivalents,
        'Share Based Compensation' => :share_based_compensation,
        'Stock-based compensation' => :share_based_compensation,
        'Net Cash Flow - Business Acquisitions and Disposals' => :net_cash_flow_business_acquisitions_and_disposals,
        'Acquisitions and disposals' => :net_cash_flow_business_acquisitions_and_disposals,
        'Net Cash Flow - Investment Acquisitions and Disposals' => :net_cash_flow_investment_acquisitions_and_disposals,
        'Free Cash Flow' => :free_cash_flow
    }

    def income_stat_mapping
      INCOME_STAT_MAPPING
    end

    def balance_sheet_mapping
      BALANCE_SHEET_MAPPING
    end

    def cashflow_statement_mapping
      CASH_FLOW_STAT_MAPPING
    end

    def init_years(row, h)
      dates = row.drop(1)
      dates = dates.map do |cell|
        time = cell.value
        h[time] = {}
        h[time][:report_date] = time.to_s
        time
      end
      [dates, h]
    end


    def map_data(type, mapping, form_type=FORM_10K)
      i = 0
      h = {}
      dates = []
      book = workbook(type, form_type)
      return if book.nil?
      book.each_row_streaming do |row|
        next if row.blank?
        if i == 0
          dates, h = init_years(row, h)
        else
          label = row.first.value.strip
          kfi = row.drop(1)
          kfi.each_with_index do |cell, index|
            h[dates[index]][mapping[label]] = cell.value
          end
        end
        i += 1
      end
      h
    rescue => e
      puts "Couldn't read file #{type}. Error: #{e}"
      record_error(type, 'unreadable', e)
      raise e
    end

  end

end
