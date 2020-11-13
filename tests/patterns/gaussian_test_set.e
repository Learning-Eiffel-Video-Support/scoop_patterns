note
	description: "[
		Demonstration of how Gaussian elimination can be solved with futures.
	]"
	testing: "type/manual"

class
	GAUSSIAN_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	gaussian_test
			-- New test routine
		note
			testing:  "covers/{GAUSS_APPLICATION}",
						"execution/serial", "execution/isolated"
			EIS: "name=gaussian_elimination_solution",
					"src=https://www.youtube.com/watch?v=2j5Ic2V7wq4"
		local
			l_demo: GAUSS_APPLICATION
		do
			create l_demo.make
		end

end


