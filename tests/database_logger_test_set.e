note
	description: "[
		Demonstration of Database Logger
	]"
	testing: "type/manual"

class
	DATABASE_LOGGER_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	database_logger_test
			-- Demonstration "database-logger"
		note
			testing:  "covers/{DATABASE_LOGGER}",
						"execution/isolated",
						"execution/serial"
		local
			l_logger: DATABASE_LOGGER_APPLICATION
		do
			create l_logger.make
		end

end


