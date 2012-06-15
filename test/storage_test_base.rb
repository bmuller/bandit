require 'date'

module StorageTestBase
  def teardown
    @storage.clear!
  end

  def test_participant_storage
    exp = new_experiment
    alt = exp.alternatives.first

    start = Bandit::DateHour.now
    @storage.incr_participants(exp, alt)
    assert_equal @storage.participant_count(exp, alt), 1
    @storage.incr_participants(exp, alt, 2)
    assert_equal @storage.participant_count(exp, alt), 3
    assert_equal @storage.participant_count(exp, alt, Bandit::DateHour.now), 3

    assert_equal @storage.alternative_start_time(exp, alt), start

    future = Bandit::DateHour.new(Date.today+1, Time.now.hour)
    @storage.incr_participants(exp, alt, 123, future)
    assert_equal @storage.participant_count(exp, alt, future), 123

    assert_equal @storage.participant_count(exp, "nonexistant"), 0
  end

  def test_conversion_storage
    exp = new_experiment
    alt = exp.alternatives.first

    @storage.incr_conversions(exp, alt)
    assert_equal @storage.conversion_count(exp, alt), 1
    @storage.incr_conversions(exp, alt, 2)
    assert_equal @storage.conversion_count(exp, alt), 3
    assert_equal @storage.conversion_count(exp, alt, Bandit::DateHour.now), 3

    future = Bandit::DateHour.new(Date.today+1, Time.now.hour)
    @storage.incr_conversions(exp, alt, 123, future)
    assert_equal @storage.conversion_count(exp, alt, future), 123

    assert_equal @storage.conversion_count(exp, "nonexistant"), 0
  end

  def test_player_storage
    player = Bandit.player
    exp = new_experiment

    @storage.player_state_set(exp, player, "something", 123)
    assert_equal @storage.player_state_get(exp, player, "something"), 123
    
    assert_equal @storage.player_state_get(exp, player, "nonexistant"), nil
  end
end
