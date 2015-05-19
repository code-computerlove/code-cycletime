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

	trello_cycle_time = AgileTrello::TrelloCycleTime.new(
		public_key: 'addb4649842bd95aa535abe99d5ecc38',
		access_token: ENV['TRELLO_TOKEN']
	)

	cycle_time_calculations.each do |cycle_time_calculation|
		calculation_name = cycle_time_calculation["name"]
		puts "Start calculation for #{calculation_name}"
		board_cycle_times = board_cycle_times_factory.create(calculation_name)
		BoardSixWeekCycleTime.new(trello_cycle_time, board_cycle_times, cycle_time_calculation).calculate
		puts "End calculation for #{calculation_name}"
	end
end
