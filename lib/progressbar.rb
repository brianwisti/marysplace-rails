# From https://coderwall.com/p/ijr6jq
class ProgressBar

  def initialize(name, total)
    @name    = name
    @total   = total
    @counter = 1
  end

  def increment
    complete = sprintf("%#.2f%", ((@counter.to_f / @total.to_f) * 100))
    print "\r\e[0K#{@name} #{@counter}/#{@total} (#{complete})"
    @counter += 1
  end

end
