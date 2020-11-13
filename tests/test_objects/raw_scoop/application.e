note
	description: "Test {APPLICATION}"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			create person.make
			create thing
		end

feature -- Access

	person: separate PERSON

	thing: separate ANY

end
