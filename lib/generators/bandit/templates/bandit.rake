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

  desc 'test the configured player'
  task :test_player, [:experiment, :force] => [:environment] do |t, args|
    storage = Bandit.storage
    exp = Bandit.get_experiment args[:experiment].intern
    raise "No such experiment defined: #{args[:experiment]}" if exp.nil?

    force = !!args[:force]
    if !(Rails.env.development? || Rails.env.test?) && !force
      raise "Be careful! Environment is #{Rails.env}. " 
            "Call with force=true to continue"
    end

    class << Bandit.player
      def memoize(key, time=0)
        yield
      end
    end

    rates = {}
    exp.alternatives.each { |alt, i|
      rates[alt] = rand
    }

    storage.clear!
    1000.times { |_|
      alt = exp.choose
      exp.convert!(alt) if rand < rates[alt]
    }

    printf "%10s%10s%10s%10s\n", *%w(alts visits convert rate)
    exp.alternatives.each { |alt|
      v = exp.participant_count(alt)
      c = exp.conversion_rate(alt)
      r = rates[alt]

      printf "%10.4f%10d%10.4f%10.4f\n", alt, v, c, r
    }
  end
end
