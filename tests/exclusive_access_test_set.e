note
	description: "[
		Exclusive Access
	]"
	testing: "type/manual"
	EIS: "name=separate_calls",
			"src=https://www.eiffel.org/doc/solutions/Exclusive_Access"

class
	EXCLUSIVE_ACCESS_TEST_SET

inherit
	TEST_SET_SUPPORT

	START_HERE_DOCS

feature -- Test routines

	test_1_separate_inline
			-- New test routine
		note
			testing:  "covers/{X}.f",
						"execution/isolated",
						"execution/serial"
			explanation: "[
				In {SEPARATE_CALLS_TEST_SET}.test_1_f_of_x we made a call to `do_call'
				to demonstrate how to get controlled access to a separate instance of
				{X} and then call the feature named `f' on it, passing 42 as an argument.
				
				In this example, we are going to do precisely the same thing, but using
				a "separate in-line block" instead of creating another feature like `do_call'
				and calling it.
				
				In the code (below) we use the "separate [reference] as [local] do [code-block] end"
				Eiffel language structure. The "create {separate X}" is what creates an instance of
				{X} in a separate Region+Processor. The [local] is precisely the same thing as
				the `my_x' argument was in the previous example (e.g. {SEPARATE_CALLS_TEST_SET}).
				
				The new [local], called `sl_x' (read-as "separate_local_x") is now "controlled",
				which gives our local processor exclusive access to an instance of {X} in its
				created Region, through its handler on that region. Now that we have exclusive
				access, we can safely make our call to `f' on {X}, passing it 42 as an argument.
				]"
		do
			separate create {separate X} as sl_x do
				sl_x.f (42)
			end

				-- 42 was easy because it is an expanded type that allows itself to be
				--	easily copied ("copy semantics") when passed as an argument in a
				-- 	separate call like `f'.

				-- Now, however, we want to pass something more difficult: A reference object.
				--	Reference objects must themselves be separate in order to pass them,
				--	where the receiving processor can get exclusive access to the argument.
				--	If we were to pass an argument controlled by the Current processor, then
				--	the receiving separate processor would be unable to gain exclusive access.
				--	This would put us in a state where both the Current processor and the
				--	separate processor could change data on the shared-reference. This is a
				--	dangerous situation, we Eiffel SCOOP disallows it. We must pass a separate
				--	argument reference when passing reference objects as arguments.

			separate create {separate X} as sl_x do

					-- Pass a manifest-string declared as separate.
				sl_x.f_with_ref_argument ({separate STRING} "Fred")

					-- Test to ensure that our separate {X}.name actually got "Fred"
				assert_strings_equal ("has_fred", "Fred", create {STRING}.make_from_separate (sl_x.name))

					-- Later, we will see how to easily handle passing objects around
					-- 	between processes using the notion of "importer".
			end
		end

end


