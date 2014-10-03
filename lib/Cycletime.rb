require 'TrelloCycleTime'
require 'json'
require_relative 'BoardSixWeekCycleTime'

class BoardCycleTimes
	MAX_ENTRIES = 30

	def initialize(repository, calculation_name)
		@repository = repository
		@calculation_name = calculation_name
	end

	def add(cycle_time_entry)
		puts "#{@calculation_name} - #{cycle_time}"
		cycle_times = repository.get(@calculation_name)
		cycle_times = {'_id' => @calculation_name, 'cycle_times' => []} unless cycle_times
		cycle_times['cycle_times'].pop() if cycle_times['cycle_times'].length == MAX_ENTRIES 
		cycle_times['cycle_times'].push(cycle_time_entry)
		@repository.upsert({'_id' => @calculation_name}, cycle_times)
	end
end

class BoardCycleTimesFactory 
	def initialize(repository)
		@repository = repository
	end

	def create(calculation_name)
		BoardCycleTimes.new(repository, calculation_name)
	end
end

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
