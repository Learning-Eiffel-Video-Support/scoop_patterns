note
	description: "[
		Sanity Check to ensure SCOOP is setup properly in project.
	]"
	testing: "type/manual"
	EIS: "name=SCOOP_setup",
		"src=https://www.eiffel.org/doc/solutions/Getting_Started_with_SCOOP"

class
	SANITY_CHECK_TEST_SET

inherit
	TEST_SET_SUPPORT

	START_HERE_DOCS

feature -- Test routines

	placeholder_test
			-- This is here so this class shows up in AutoTest tool.
			-- See `sanity_check_test' below.
		do

		end

feature {NONE} -- Implementation

	sanity_check_test (a_string: separate STRING)
			-- This will not show as a "test" because of the argument.
		local
			str: separate STRING -- Remove "separate" keyword and this ought to generate an error
									-- if SCOOP is setup properly.
		do
			str := a_string
		end

end


