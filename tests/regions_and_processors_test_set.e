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

	START_HERE_DOCS

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
				
				In the code below, we want to test to ensure that {PERSON}.name defaulted to "Frank".
				Our first step is to object a "Controlled" reference to `l_app.person'. We do this by
				using what is called an "in-line separate code block". This is in the pattern of:
				
				separate [reference] as [local] do [code-block] end
				
				The [local] is variable created from [reference] that is "local" to the "do ... end"
				block of code. In this case, the `sl_person' local is created from `l_app.person'.
				The prefix text "sl" is a naming-convention, where the "S" means "separate" and the
				"L" means "local" (e.g. separate local). The convention is used so you can easily
				recognize when the separate-local is actually used within the context of the code.
				
				Once we have our "Controlled-reference" to {PERSON} on l_app, we need to grab a copy
				of {PERSON}.name from the other Region. To do this, we create an "attachment local"
				using another in-line code structure:
				
				attached [object] as [local] then [code-block] end
				
				The [object] is created using an in-line creation: "create {STRING}". We use the
				`make_from_separate' creation procedure, which allows us to reference the name feature
				of the controlled separate reference `sl_person'. So, the `name' feature from the other
				region is now brought over and a copy of it is in `al_name'.
				
				Like the "sl" prefix notation, "al" stands for "attachment local". Again, this is so
				we can easily recognize both our use of the local and its scope simply by reading its
				name.
				
				Finally, we are ready to do our "test". In this case, we will test that `al_name' and
				the manifest-string "Frank" are equal by calling and using the `assert_strings_equal'
				test-assertion (see: TEST_SET_SUPPORT class for more, if you like).
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


