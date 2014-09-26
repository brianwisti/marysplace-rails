# An attempt to encapsulate functionality required by summary reports.
module Reportable

  def set_report_year
    @year ||= params[:year].to_i
  end

  def set_report_month
    @month ||= params[:month].to_i
  end

  def set_report_day
    @day ||= params[:day].to_i || 1
  end

  def set_report_span
    @span = Time.zone.local(@year, @month, @day, 0, 0)
  end

  def use_today
    today = Date.today
    @year = today.year
    @month = today.month
    @day = today.day
  end

  def use_daily_report_range
    set_report_day
    set_report_month
    set_report_year
    set_report_span
    set_time_range
  end

  def use_monthly_report_range
    set_report_month
    set_report_year
    set_report_span
    set_time_range
  end

  def use_annual_report_range
    set_report_year
    set_report_span
    set_time_range
  end

  def set_time_range
    if @span
      @time_range ||= day_of_report || month_of_report || year_of_report
    end
  end

  def day_of_report
    if @year and @month and @day
      @span.strftime "%A, %B %d %Y"
    end
  end

  def month_of_report
    if @year and @month
      @span.strftime "%B %Y"
    end
  end

  def year_of_report
    @year
  end
end
