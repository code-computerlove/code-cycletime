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
		public_key: 'e185a8128064891a8961802a3d86b08e',
		access_token: ENV['TRELLO_TOKEN']
	)

	cycle_time_calculations.each do |cycle_time_calculation|
		board_cycle_times = board_cycle_times_factory.create(cycle_time_calculation["name"])
		BoardSixWeekCycleTime.new(trello_cycle_time, board_cycle_times, cycle_time_calculation).calculate
	end
end
