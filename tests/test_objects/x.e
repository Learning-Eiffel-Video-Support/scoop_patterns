note
	description: "{X} class for SCOOP reference testing"

class
	X

feature -- Access

	f (i: INTEGER)
			--
		do
			do_nothing
		end

	f_with_ref_argument (s: separate STRING)
			--
		do
			name := (create {STRING}.make_from_separate (s))
		end

	my_query (i: INTEGER): INTEGER
			-- Queries like this will run synchronously, because the
			--	caller in the other Region must "wait-by-necessity" for
			--	its `Result' to come back.
		do
			Result := i + 1
		end

feature -- Access

	name: STRING
		attribute
			create Result.make_empty
		end

end
