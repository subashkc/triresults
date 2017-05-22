module Api
	class ResultsController < ApplicationController

		def index
			if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results"
			else
				@race = Race.find(params[:race_id])
				@entrants = @race.entrants
				max_updated_at = @entrants.max(:updated_at)
				response.headers['Last-Modified'] = max_updated_at
				
				# fresh_when last_modified: max_updated_at
				if stale?(last_modified: max_updated_at)
					render "index", :object => @entrants
				end
			end
		end

		def show
			if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
			else
				@result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
				render :partial => "result", :object => @result
			end
		end

		def update
			entrant = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
			if result = params[:result]
				if result[:swim]
					entrant.swim = entrant.race.race.swim
					entrant.swim_secs = result[:swim].to_f
				end
				if result[:t1]
					entrant.t1 = entrant.race.race.t1
					entrant.t1_secs = result[:t1].to_f
				end
				if result[:bike]
					entrant.bike = entrant.race.race.bike
					entrant.bike_secs = result[:bike].to_f
				end
				if result[:t2]
					entrant.t2 = entrant.race.race.t2
					entrant.t2_secs = result[:t2].to_f
				end
				if result[:run]
					entrant.run = entrant.race.race.run
					entrant.run_secs = result[:run].to_f
				end
			end
			entrant.save
			render nothing: true, status: :ok
		end

		private

		# def results_params
		# 	params.require(:result).permit(:swim, :t1, :bike, :t2, :run)
		# end

	end
end