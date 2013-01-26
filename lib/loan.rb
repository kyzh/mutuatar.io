class Loan
  def initialize (m,t,r)
    @monthly  = t / m # opts[:a].to_i / opts[:m].to_i
    @rate     = r #opts[:r].to_f
    @loan     = t
    @month    = m
    @rest     = t % m
    @interest = 0
  end
  
  def interest (sum)
    (sum.to_f / 100) * @rate.to_f
  end
  
  def repayment (r)
    interest(r) + @monthly
  end
  
  def start
    @month.times {|x|
      @interest = @interest + interest((@loan - @rest ) - x * @monthly) + @rest
      @rest = 0
      p "The interest is #{interest((@loan - @rest) - x * @monthly)}, this repayment is #{@monthly + interest(@loan - x * @monthly)} for month #{x}" 
    }
  p "Initial loan of #{@loan} on #{@month} month  (#{@monthly}/month) at a rate of #{@rate}"
  p "Total paid is #{@loan + @interest}, for #{@interest} of interest, the overall rate is #{@interest / @loan.to_f * 100}"
  end
end

