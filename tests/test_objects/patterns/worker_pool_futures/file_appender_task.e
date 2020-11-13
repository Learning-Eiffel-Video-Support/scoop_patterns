note
	description: "[
		The file appender task doesn’t return a result. Therefore it has to inherit
		from CP_DEFAULT_TASK. This inheritance is necessary to be able to submit it to
		a worker pool later.
		]"

class
	FILE_APPENDER_TASK

inherit
	CP_DEFAULT_TASK

create
	make, make_from_separate

feature {NONE} -- Initialization

	make (a_path, a_content: STRING)
			-- Create a new task to read the content from ‘a_path’.
		do
			path := a_path
			content := a_content
		end

feature {CP_DYNAMIC_TYPE_IMPORTER} -- Initialization

	make_from_separate (other: separate like Current)
			-- <Precursor>
		do
			create path.make_from_separate (other.path)
			create content.make_from_separate (other.content)
			promise := other.promise
		end

feature -- Access

	path: STRING
			-- The path of the file to write to.

	content: STRING
			-- The content to be written.

feature -- Basic operations

	run
			-- <Precursor>
	local
		l_file: PLAIN_TEXT_FILE
	do
		create l_file.make_open_append (path)
		l_file.put_string (content)
		l_file.close
	end

end
