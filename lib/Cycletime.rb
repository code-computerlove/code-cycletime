require 'TrelloCycleTime'
require 'json'
require_relative './BoardSixWeekCycleTime'
require_relative './MongoRepository'
require_relative './BoardCycleTimesFactory'

unless Time.now.saturday? || Time.now.sunday?
	file = File.read("#{File.dirname(__FILE__)}/config.json")
	cycle_time_calculations = JSON.parse(file)
	repository = MongoRepository.new(ENV['MONGO_CONN'], 'production', 'cycle_time')
	board_cycle_times_factory = BoardCycleTimesFactory.new(repository)

	cycle_time_calculations.each do |cycle_time_calculation|
		trello_cycle_time = AgileTrello::TrelloCycleTime.new(
			public_key: 'addb4649842bd95aa535abe99d5ecc38',
			access_token: ENV['TRELLO_TOKEN']
		)
		board_cycle_times = board_cycle_times_factory.create(cycle_time_calculation["name"])
		BoardSixWeekCycleTime.new(trello_cycle_time, board_cycle_times, cycle_time_calculation).calculate
	end
end
