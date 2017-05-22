module Api
	class RacesController < ApplicationController
		before_action :set_race, only: [:update, :destroy]

		rescue_from Mongoid::Errors::DocumentNotFound do |exception|
			if !request.accept || request.accept == "*/*"
				render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
			elsif request.accept == "application/json"
				render json: {:msg => "woops: cannot find race[#{params[:id]}]"}, status: :not_found
			else
				render status: :not_found, template: "api/error_msg", locals: {:msg => "woops: cannot find race[#{params[:id]}]"}
			end
		end

		rescue_from ActionView::MissingTemplate do |exception|
			render plain: "woops: we do not support that content-type[#{request.accept}]", status: :unsupported_media_type
		end

		def index
			if !request.accept || request.accept == "*/*"
				render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]}"
			else
			end
		end

		def show
			if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:id]}"
			else
				@race = Race.find(params[:id])
				render @race
			end
		end

		def create
			if !request.accept || request.accept == "*/*"
				render plain: "#{params[:race][:name]}", status: :ok
				# render plain: :nothing, status: :ok
			else
				@race = Race.new(race_params)
				respond_to do |format|
					if @race.save
						format.text { render plain: @race.name, status: :created }
					else
						format.text { render plain: @race.errors, status: :unprocessable_entity }
					end
				end
			end
		end

		def update
			if @race.update(race_params)
				render json: @race.to_json, status: :ok
			else
				render plain: @race.errors, status: :unprocessable_entity
			end
		end

		def destroy
			if @race.destroy
				render nothing: true, status: :no_content
			else
				render plain: @race.errors, status: :unprocessable_entity
			end
		end

		private

		def race_params
			params.require(:race).permit(:date, :name)
		end

		def set_race
			@race = Race.find(params[:id])			
		end

	end
end