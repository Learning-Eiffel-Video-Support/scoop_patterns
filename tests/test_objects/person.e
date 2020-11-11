note
	description: "Test {PERSON}"
	scoop: "PERSON"

class
	PERSON

create
	make

feature {NONE} -- Initialization

	make
		do
			-- create name.make_empty <-- No need to create. See `name'.
			create thing
		end

feature -- Access

	name: STRING
			-- Defaults `name' to "Frank".
		attribute
			Result := "Frank"
		end

	thing: separate ANY

end
