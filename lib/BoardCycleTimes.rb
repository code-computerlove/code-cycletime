class BoardCycleTimes
	MAX_ENTRIES = 30

	def initialize(repository, calculation_name)
		@repository = repository
		@calculation_name = calculation_name
	end

	def add(cycle_time_entry)
		puts "#{@calculation_name} - #{cycle_time_entry.mean}"
		cycle_time_value = {
			:date => DateTime.now.strftime('%d-%m-%Y'),
			:mean => cycle_time_entry.mean,
			:standard_deviation => cycle_time_entry.standard_deviation
		}
		cycle_times = @repository.get(@calculation_name)
		cycle_times = {'_id' => @calculation_name, 'cycle_times' => []} unless cycle_times
		cycle_times['cycle_times'].pop() if cycle_times['cycle_times'].length == MAX_ENTRIES 
		cycle_times['cycle_times'].push(cycle_time_value)
		@repository.upsert({'_id' => @calculation_name}, cycle_times)
	end
end