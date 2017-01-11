class Report < ActiveRecord::Base
	serialize :failed_cases
end
