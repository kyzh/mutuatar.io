class Morgage
  attr_reader :property, :deposit_rate, :deposit, :principal, :interest, :length, :loan_balance, :conveyancing, :survey, :monthly_interest, :stamp_duty, :monthly_repayment, :interest_paid, :capital_paid, :upfront_paid, :overall_spending, :overall_cost, :depreciation, :depreciation_length, :appreciation, :appreciation_rate, :insurance, :rent, :rents, :ground_lease, :charges, :added_value, :yield, :occupancy, :resell, :insurance_total, :fees, :repayments
  def initialize (p,d,i,l,c,s,a,w,f,r,g,m,v,o,u)
    @property            = p # opts[:a]     # Property value
    @deposit_rate        = d
    @deposit             = @property * (d/100.to_f)	# opts[:d] # Deposit value computed from percentage required by lender.
    @principal           = @property - @deposit		# Morgage sum, what will be borrowed from lender
    @interest            = i				# Annual interest rate that are charge on the sum left to pay  
    @length              = l				# Morgage length in months
    @loan_balance        = @principal
    @conveyancing        = c                		# Money spent on conveyancing http://www.theadvisory.co.uk/conveyancing-quote.php
    #base is between £300 - £1,200, then fees can add between 250 and 1300, then not to forget VAT on the base and some fees.
    @survey              = s                		# At least a Basic Morgage Valuation will be required by the lender
    #Basic Mortgage Valuation 1‰ of the property + charge.
    #Homebuyer's Survey 2.5‰ of the property + arrangement fee
    #Building Survey 6‰ + charge. Everything needs VAT.
    @monthly_interest    = 0 
    @stamp_duty          = 0 
    @monthly_repayment   = 0
    @interest_paid       = 0
    @capital_paid        = 0
    @upfront_paid        = 0
    @overall_spending    = 0
    @overall_cost        = 0 
    @depreciation        = 0
    @depreciation_length = w
    @appreciation        = 0
    @appreciation_rate   = a 
    @insurance		 = f
    @rent		 = r
    @rents		 = 0
    @ground_lease	 = g
    @charges		 = m
    @added_value	 = v
    @yield		 = 0
    @occupancy		 = o
    @resell		 = u
    @insurance_total	 = 0
    @fees		 = 0
    @repayments          = []
    start
  end

  def compute_resell
    puts "Compute the total paid todo" 
  end

  def compute_loan
    @monthly_interest   = (@interest / (12 * 100)).round(6)
    @monthly_repayment  = @principal * ( @monthly_interest / (1 - (1 + @monthly_interest) ** -@length))
    @length.times do |m|
      @repayments << { "month" => m ,"interest"=> @loan_balance * @monthly_interest, "capital"=> @monthly_repayment - @loan_balance * @monthly_interest, "balance" => @loan_balance - @monthly_repayment}
      @loan_balance -= @monthly_repayment - @loan_balance * @monthly_interest
    end
    # Ugly fix for the repayment
    # the float / rounding needs doing 
    @repayments[@length - 1]['balance'] = 0
    @repayments[@length - 1]['capital'] = @repayments[@length - 2]['balance'] - @repayments[@length - 1]['interest']
  end

  def compute_rent
    @rents = @rent * @length
  end

  def compute_fees
    @fees = ((@ground_lease + @charges + @insurance_total) * @length ) / 12.0
  end

  def appreciation_depreciation
    @appreciation = ((@property * ((@appreciation_rate / 100.0 )/ 12.0 )) * @length).round(2)
    @depreciation = (((@property / @depreciation_length) / 12.0) * @length).round(2)
  end

  def stamp
    @stamp_duty = case @property
      when 0..125000 then 0
      when 125001..250000 then @property * 0.01
      when 250001..500000 then @property * 0.03
      when 500001..1000000 then @property * 0.04
      when 1000001..2000000 then @property * 0.05
      else @property * 0.07
    end
  end

  def gross_yield
    annual_income = (@rent * 12) * (@occupancy / 100.0)
    @yield = (annual_income / @property.to_f) * 100
  end

  def compute_totals
    @capital_paid     = @repayments.collect{|m| m["capital"]}.inject(:+)
    @interest_paid    = @repayments.collect{|m| m["interest"]}.inject(:+)
    @upfront_paid     = @deposit       + @stamp_duty + @survey + @conveyancing 
    @overall_cost     = @interest_paid + @stamp_duty + @survey + @conveyancing +  @fees
    @overall_spending = @interest_paid + @stamp_duty + @survey + @conveyancing +  @fees + @property 
  end 

  def request
    puts "property=#{@property}&deposit_rate=#{@deposit_rate}&deposit=#{@deposit}&principal=#{@principal}&interest=#{@interest}&length=#{@length}&loan_balance=#{@loan_balance}&conveyancing=#{@conveyancing}&survey=#{@survey}&monthly_interest=#{@monthly_interest}&stamp_duty=#{@stamp_duty}&monthly_repayment=#{@monthly_repayment}&interest_paid=#{@interest_paid}&capital_paid=#{@capital_paid}&upfront_paid=#{@upfront_paid}&overall_spending=#{@overall_spending}&overall_cost=#{@overall_cost}&depreciation=#{@depreciation}&depreciation_length=#{@depreciation_length}&appreciation=#{@appreciation}&appreciation_rate=#{@appreciation_rate}&repayments=#{@repayments}"
  end

  def start
    compute_resell
    compute_loan
    compute_rent
    compute_fees
    appreciation_depreciation
    stamp
    gross_yield
    compute_totals
    #request
  end 
end

