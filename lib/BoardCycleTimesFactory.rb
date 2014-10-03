require_relative './BoardCycleTimes'

class BoardCycleTimesFactory 
	def initialize(repository)
		@repository = repository
	end

	def create(calculation_name)
		BoardCycleTimes.new(@repository, calculation_name)
	end
end