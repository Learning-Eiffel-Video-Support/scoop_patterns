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

	my_query (i: INTEGER): INTEGER
			-- Queries like this will run synchronously, because the
			--	caller in the other Region must "wait-by-necessity" for
			--	its `Result' to come back.
		do
			Result := i + 1
		end

end
