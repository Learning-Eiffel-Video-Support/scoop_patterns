note
	description: "[
		Regions and Processors
	]"
	testing: "type/manual"
	EIS: "name=regions_and_processors",
			"src=https://www.eiffel.org/doc/solutions/Regions_and_Processors"

class
	REGIONS_AND_PROCESSORS_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	test_1
			-- New test routine
		note
			testing:  "covers/{APPLICATION}.make", "covers/{APPLICATION}.person", "covers/{APPLICATION}.thing",
						"covers/{PERSON}.make", "covers/{PERSON}.name", "covers/{PERSON}.thing",
						"execution/isolated", "execution/serial"
			EIS: "name=regions_and_processors",
				"src=https://www.eiffel.org/doc/solutions/Regions_and_Processors"
			EIS: "name=regions_and_processors_graphic",
					"src=$(system_path)/docs/SCOOP regions.png"
			EIS: "name=regions_and_processors_debugger",
					"src=$(system_path)/docs/regions_and_processors_test_1_debugger.png"
			description: "[
				Please refer to the code below and the `regions_and_processors' EIS link above.
				
				Running this test will create the precise scenario shown in the Regions and Processors
				documentation linked in the EIS above. If you run this test in the AutoTest debugger,
				and stop the code immediately after the "create l_app.make" creation call, you can
				examine the Threads tool in the debugger to see the various SCOOP processors created
				and running in their own regions with their own objects.
				]"
		local
			l_app: APPLICATION
		do
			create l_app.make

			separate l_app.person as sl_person do
				check attached (create {STRING}.make_from_separate (sl_person.name)) as al_name then
					assert_strings_equal ("frank", "Frank", al_name)
				end
			end

		end

end


