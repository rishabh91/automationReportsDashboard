require 'nokogiri'
require 'date'
class FileUploadController < ApplicationController
	
	
  	def new
 
	end
	def show_data
 	 	@module_name = params[:module]
  		uploaded_io = params[:file]
  		@date = Date.parse(params[:start_date])
  		if @module_name and uploaded_io
  			@uploaded_file_name = uploaded_io.original_filename
  			
  			if uploaded_io.content_type == "text/html"
  
  				File.open(Rails.root.join('public', 'upload', uploaded_io.original_filename), 'wb') do |file|
    				file.write(uploaded_io.read)
  				end
  			else 
  				flash.now[:error] = "Only supports html files, You sure you have the right report file from freshservice automation?"
  				render "new"
  				return false 
  			end

  			report_details = parse_file
  			
  			
  			if !report_details.blank?
  				@errors = report_details["failed_desc"]
	  			report = Report.new
	  			report.module = @module_name
	  		  	report.depdate = @date
	  			report.passed = report_details["pass"]
	  			report.failed = report_details["failed"]
	  			report.total = report_details["total_cases"]
	  			report.failed_cases = report_details["failed_desc"]
	  			report.save
	  			delete_uploaded_file
	  			render 'show'
  			else
  				render 'error'
  			end
  		else
  			render 'error'
  		end
	end



private
	def parse_file
		begin
			doc = Nokogiri::HTML(File.open(Rails.root.join('public','upload',@uploaded_file_name)))
			tables = doc.xpath("//table")[0]
			parsed = {}
			failed_desc =[]
			total_cases = 0
			tables.xpath("//tr").each do |t|
		
				if t.text.include?"PASSED"
					total_cases += 1
				elsif t.text.include?"FAILED"
					failed_desc << t.text.split("FAILED")
					total_cases += 1
				end
			end
			parsed["total_cases"] = total_cases
			parsed["failed"] = failed_desc.size
			parsed["pass"] = total_cases - failed_desc.size
			parsed["failed_desc"] = failed_desc
			return parsed
		rescue Exception => e 
			#remove_file
		end
	end
	def delete_uploaded_file
  		FileUtils.rm(Rails.root.join('public','upload',@uploaded_file_name))
	end


  

end
