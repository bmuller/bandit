namespace :bandit do

  desc "Generate fake data for a named experiment"
  task :populate_data, [:experiment] => [:environment] do |t, args|
    storage = Bandit.storage
    exp = Bandit.get_experiment args[:experiment].intern
    raise "No such experiment defined: #{args[:experiment]}" if exp.nil?

    start = Bandit::DateHour.new((Date.today - 7), 0)
    start.upto(Bandit::DateHour.now) { |dh|
      puts "Adding data for alternatives on #{dh}"
      exp.alternatives.each { |alt|
        count = 1000 + rand(1000)
        storage.incr_participants(exp, alt, count, dh)
        storage.incr_conversions(exp, alt, (rand * count).floor, dh)
      }
    }
  end

end
