note
	description: "[
		Separate Calls
	]"
	testing: "type/manual"
	EIS: "name=separate_calls",
			"src=https://www.eiffel.org/doc/solutions/Separate_Calls"

class
	SEPARATE_CALLS_TEST_SET

inherit
	TEST_SET_SUPPORT

	START_HERE_DOCS

feature -- Test routines

	test_1_f_of_x
			-- Example 1
		note
			testing:  "covers/{SEPARATE_CALLS_TEST_SET}.do_call",
						"covers/{X}.f",
						"execution/isolated",
						"execution/serial"
			explanation: "[
				The "create {separate X}" below spins up a new Region, then a new
				Processor for that Region, and (finally) creates an {X} object, placing
				it within the Region and putting it under the control of that Regions
				Processor.
				
				NOTE: If you run this test in "debugging mode" from the AutoTest tool,
				you will be able to see this happen in the Threads-tool in the debugger
				interface. To illustrate, we have included a screenshot of the debugger
				and Threads-tool if you like.
				
				The two red arrows are pointing at the separate instance of `my_x' as it
				is contained within its own Region+Processor. All region and processor
				pairs are givin a PID (Processor or Process ID). The Threads tool in the
				debugger is there so you can examine precisely which PIDs are created.
				To help you keep your wits-about-you during debugging, the Threads tool
				has a column for "Note", where you can type in a description of the PID
				to help you keep track of what PID is handling what separate process call
				at any given time.
				]"
			EIS: "name=separate_calls_test_1_debugger",
					"src=$(system_path)/docs/separate_calls_test_1_debugger.png"
			EIS: "name=separate_calls_test_1_call_to_f_callstack",
					"src=$(system_path)/docs/separate_calls_test_1_call_to_f_callstack.PNG"
		do
			do_call (create {separate X})
			do_another_call (create {separate X})
		end

	test_2_synch_vs_asynch
			-- Test code showing the difference between synchronous and asynchronous
			--	running code.
		note
			testing:  "covers/{SEPARATE_CALLS_TEST_SET}.do_call",
						"covers/{SEPARATE_CALLS_TEST_SET}.do_query",
						"covers/{X}.f", "covers/{X}.my_query",
						"execution/isolated",
						"execution/serial"
			explanation: "[
				The call to `do_call' will run synchronously. The call to `do_query' will not.
				Take a look at `do_query' (below) and read the notes to understand why.
				]"
		local
			x: separate X
		do
			create x
			do_call (x)
			do_query (x)
		end

feature {NONE} -- Implementation: Test Support

	do_call (my_x: separate X)
		note
			explanation: "[
				First, the argument `my_x' (above) is "controlled" because it is an
				"argument-of-a-separate-type". This means, the Region+Processor executing
				`do_call' (this routine) has exclusive control over `my_x'.
				
				Second, the call to `f' (below) on `my_x' sends a message to the separate 
				Region+Processor (which actually has {X} within it) asking it to execute `f'
				with an INTEGER argument of 42.
				
				Third, the separate Region+Processor that actually has {X} will then execute
				`f', passing it 42, when that Processor is ready.
				
				Therefore, there is always a two-step-dance involved in separate-calls. There
				is the registration or logging of the message (request) to execute and then
				there is the actual execution, which is performed by the controlling processor
				in the separate region.
				]"
		do
			my_x.f (42)
		end

	do_another_call (my_x: separate X)
			-- Object {X} is now controlled because it is
			-- 	an argument of this feature. The separate-call
			--	below is now a valid and controlled separate-call.
		do
			my_x.f (42)
		end

	do_query (my_x: separate X)
			-- Attempt a separate synchronous call on `my_x'.
			--	However, it runs synchronous and not asynch. Why?
		note
			explanation: "[
				The call to `my_x.my_query (42)' will not run concurrently because
				the caller (this routine, region, process) must wait to get its
				answer (Result) back before it can continue. This "wait-by-necessity"
				means that the current process will stop and wait for the separate
				processor to finish its query-call (e.g. `my_query') and then the
				code (here) can continue.
				
				Later on, we will learn both a raw and SCOOP pattern library way of
				having a query call do its work, where a calling process can continue
				and then pick up the results later on, when the query call is finished.
				This allows "long-running-queries" to execute on another processor thread
				but it does mean that eventually we wait for the results if we get to 
				a place in our code where we need the result before it is done computing.
				
				You can think of this as something like putting a pie in the oven to
				bake while you do other things. But when it comes time that you want
				the pie and it is still baking, you must wait for it to finish, no matter
				how many other things you have done since you put the pie in the oven!
				
				In the synchronous query example below, we have built the code to where
				we are waiting for our pie and doing nothing else until it is finished baking.
				]"
		do
			assert_integers_equal ("43", 43, my_x.my_query (42))
		end

	do_another_query (my_x: separate X)
			-- While `my_x' as an argument is valid and controlled,
			--	the separate-call to `my_x.my_query' must wait for
			--	the Result to come back from the separate-processor.
		do
			assert_integers_equal ("43", 43, my_x.my_query (42))
		end


end


