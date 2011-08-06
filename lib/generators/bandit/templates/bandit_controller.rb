class BanditController < ApplicationController                                                                                                                                                   
  def index
    @experiments = Bandit.experiments
  end
end  
