note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	WORKER_POOL_AND_FUTURES_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	worker_pool_tests
			-- Test worker-pool SCOOP.
		note
			testing:  "covers/{FILE_READER_TASK}",
						"covers/{FILE_APPENDER_TASK}",
						"execution/isolated",
						"execution/serial"
		local
			l_io: IO_WORKER_POOL
		do
			reader_appender_raw_tests	-- Ensure our raw reader/appender classes perform
			reset_test_data_dir			-- Reset the tests/data folder
			create l_io.make			-- Examine `make' to understand process
		end

feature {NONE} -- Implementation: Prep Tests

	reader_appender_raw_tests
			-- Test the FILE_READER_TASK and FILE_APPENDER_TASK objects
			--	alone, without worker-pool.
		local
			l_reader: FILE_READER_TASK
			l_appender: FILE_APPENDER_TASK
		do
			create l_reader.make ("sample.json")
			l_reader.start
			assert_strings_equal ("has_json", sample_json, l_reader.computed)

			reset_test_data_dir

			create l_appender.make ("./tests/data/a.txt", "Hello World%N")
			l_appender.start

			create l_reader.make ("./tests/data/a.txt")
			l_reader.start
			assert_strings_equal ("hello_world", "Hello World%N", l_reader.computed)
		end

feature {NONE} -- Implementation: Helpers

	reset_test_data_dir
			-- Set-or-Reset the ./tests/data directory.
			--	Give it an empty a.txt file for testing.
		local
			l_dir: DIRECTORY
		do
			create l_dir.make ("./tests/data")
			if l_dir.exists then
				l_dir.delete_content
			else
				l_dir.create_dir
			end
			if not l_dir.is_closed then
				l_dir.close
			end
			new_empty_text_files
		end

	new_empty_text_files
			-- Make a new a.txt file.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write ("./tests/data/a.txt")
			l_file.close
			create l_file.make_create_read_write ("./tests/data/b.txt")
			l_file.close
			create l_file.make_create_read_write ("./tests/data/c.txt")
			l_file.close
		end

feature {NONE} -- Implementation: Test Strings

	sample_json: STRING = "[
{
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}
]"

end


