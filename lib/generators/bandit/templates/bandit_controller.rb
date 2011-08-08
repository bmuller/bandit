class BanditController < ApplicationController                                                                                                                                                   
  layout :bandit

  def index
    @experiments = Bandit.experiments
  end
end  
