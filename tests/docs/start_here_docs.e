note
	description: "Start here!"
	explanation: "[
			These "TEST_SET" classes are intended to be viewed in a particular order.
			
			{SANITY_CHECK_TEST_SET} -- This is here to ensure this project is set-up properly
										for SCOOP. You can also use this method in your own SCOOP
										projects as a means to know you have your project set up
										correctly.
			
			{IN_SYSTEM_TEST_SET} -- This class is here simply to bring all yet-to-be-referenced
										classes "in-system". This means that they "light-up" with
										blue-oval class icons and will function as expected in the
										Class Context Tool (below in the IDE).
										
			{REGIONS_AND_PROCESSORS_TEST_SET} -- Start by learning about Regions and Processors.
			
			{SEPARATE_CALLS_TEST_SET} -- What is a "separate call" within the context of SCOOP?
			]"

deferred class
	START_HERE_DOCS

inherit
	ANY
		undefine
			default_create
		end

feature -- Test Sets in-order

	sanity_check: detachable SANITY_CHECK_TEST_SET
	in_system: detachable IN_SYSTEM_TEST_SET
	regions_and_processors: detachable REGIONS_AND_PROCESSORS_TEST_SET
	separate_calls: detachable SEPARATE_CALLS_TEST_SET

end
