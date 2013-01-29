class Loan
  def initialize (m,t,r)
    @monthly  = t / m 
    @rate     = r 
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
    }
  end
end

