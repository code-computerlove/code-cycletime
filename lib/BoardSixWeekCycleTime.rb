class BoardSixWeekCycleTime
	ONE_DAY = 86400
	SIX_WEEKS = ONE_DAY * 42

	def initialize(trello_cycle_time, board_cycle_times, cycle_time_settings)
		@trello_cycle_time = trello_cycle_time
		@board_cycle_times = board_cycle_times
		@cycle_time_settings = cycle_time_settings
	end

	def calculate
		today = Time.now
		measurement_start_date = today - SIX_WEEKS
		average_cycle_time = @trello_cycle_time.get(
			board_id: @cycle_time_settings['board_id'],
			start_list: @cycle_time_settings['start_list'],
			end_list: @cycle_time_settings['end_list'],
			measurement_start_date: measurement_start_date
		)
		@board_cycle_times.add(average_cycle_time)
	end
end