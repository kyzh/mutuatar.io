class Morgage
  attr_reader :property, :deposit_rate, :deposit, :principal, :interest, :length, :loan_balance, :conveyancing, :survey, :monthly_interest, :stamp_duty, :monthly_repayment, :interest_paid, :capital_paid, :upfront_paid, :overall_spending, :overall_cost, :depreciation, :depreciation_length, :appreciation, :appreciation_rate, :repaiments
  def initialize (p,d,i,l,c,s,a,w)
    @property            = p # opts[:a]     # Property value
    @deposit_rate        = d
    @deposit             = @property * (d/100.to_f)	# opts[:d] # Deposit value computed from percentage required by lender.
    @principal           = @property - @deposit		# Morgage sum, what will be borrowed from lender
    @interest            = i				# Annual interest rate that are charge on the sum left to pay  
    @length              = l				# Morgage lenght in months
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
    @repaiments          = []
    start
  end

  def compute_loan
    @monthly_interest   = (@interest / (12 * 100)).round(6)
    @monthly_repayment  = @principal * ( @monthly_interest / (1 - (1 + @monthly_interest) ** -@length))
    @length.times do |m|
      @repaiments << { "month" => m ,"interest"=> @loan_balance * @monthly_interest, "capital"=> @monthly_repayment - @loan_balance * @monthly_interest, "balance" => @loan_balance - @monthly_repayment}
      @loan_balance -= @monthly_repayment - @loan_balance * @monthly_interest
    end
    @repaiments[@length - 1]['balance'] = 0
    @repaiments[@length - 1]['capital'] = @repaiments[@length - 2]['balance'] - @repaiments[@length - 1]['interest']
    @capital_paid     = @repaiments.collect{|m| m["capital"]}.inject(:+)
    @interest_paid    = @repaiments.collect{|m| m["interest"]}.inject(:+)
    @upfront_paid     = @deposit       + @stamp_duty + @survey + @conveyancing
    @overall_cost     = @interest_paid + @stamp_duty + @survey + @conveyancing
    @overall_spending = @interest_paid + @stamp_duty + @survey + @conveyancing +  @property
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

  def request
    puts "property=#{@property}&deposit_rate=#{@deposit_rate}&deposit=#{@deposit}&principal=#{@principal}&interest=#{@interest}&length=#{@length}&loan_balance=#{@loan_balance}&conveyancing=#{@conveyancing}&survey=#{@survey}&monthly_interest=#{@monthly_interest}&stamp_duty=#{@stamp_duty}&monthly_repayment=#{@monthly_repayment}&interest_paid=#{@interest_paid}&capital_paid=#{@capital_paid}&upfront_paid=#{@upfront_paid}&overall_spending=#{@overall_spending}&overall_cost=#{@overall_cost}&depreciation=#{@depreciation}&depreciation_length=#{@depreciation_length}&appreciation=#{@appreciation}&appreciation_rate=#{@appreciation_rate}&repaiments=#{@repaiments}"
  end

  def start
    compute_loan
    appreciation_depreciation
    stamp
    request
  end 
end

