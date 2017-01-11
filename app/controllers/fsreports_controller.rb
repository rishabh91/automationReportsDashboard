class FsreportsController < ApplicationController
	require 'Date'
  def index
  	#@report_object = 
  end

  def get_data
  	@module = params[:module]
  	if @module
  		startdate = Date.parse(params[:start_date])
  		enddate = Date.parse(params[:end_date])
  		@error_message = String.new
  		if startdate <= enddate
  			if @module == "All"
  				@report_object = Report.where("depdate >= ? AND depdate <= ?", startdate,enddate)
  			else
  				@report_object = Report.where("module = ? AND depdate >= ? AND depdate <= ?", @module, startdate,enddate)
  			end
  			@passed = 0
  			@failed = 0
  			@failures = []
  			if !@report_object.blank?
  				@report_object.each do |rep|
  					@passed += rep.passed
  					@failed +=rep.failed
  					@failures << rep.failed_cases
  				end
  			else
  				@error_message = "There is no Data present for the selected Date Range. Please try again."
  				render 'error' 
  				return false
  			end
  		else
  			@error_message = "End Date cant be Smaller than Start date!"
  			render 'error' 
  			return false
  		end

  		render 'viewreport'
  	else
  		@error_message = "There is no Data present for the selected Module. Please try again."
  		render 'error' 
  		return false
  	end
  end
end
