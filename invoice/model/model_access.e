note
	description: "Summary description for {MODEL_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MODEL_ACCESS

feature
	m: MODEL
		once
			create Result.make
		end

invariant
	m = m
end

