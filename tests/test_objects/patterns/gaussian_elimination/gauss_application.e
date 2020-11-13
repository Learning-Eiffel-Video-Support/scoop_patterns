note
	description: "[
		Example application that shows how Gaussian elimination 
		can be solved with futures.
		]"
	author: "Roman Schmocker"

class
	GAUSS_APPLICATION

inherit
	TEST_SET_SUPPORT

create
	make

feature -- Predefined matrices.

	normal_matrix: ARRAY [ARRAY [DOUBLE]]
		attribute
			Result :=
				<<
				{ARRAY [REAL_64]} <<  2,  1, -1,  8 >>,
				{ARRAY [REAL_64]} << -3, -1,  2, -11>>,
				{ARRAY [REAL_64]} << -2,  1,  2, -3 >>
				>>
		end

	last_row_zero: ARRAY [ARRAY [DOUBLE]]
		attribute
			Result :=
				<<
				{ARRAY [REAL_64]} << 1,  3,  1,  9 >>,
				{ARRAY [REAL_64]} << 1,  1, -1,  1 >>,
				{ARRAY [REAL_64]} << 3, 11, 5,  35 >>
				>>
		end

	zero_pivot: ARRAY [ARRAY [DOUBLE]]
		attribute
			Result :=
				<<
				{ARRAY [REAL_64]} << 0,  2,  3,  4 >>,
				{ARRAY [REAL_64]} << 1,  1,  1,  2 >>,
				{ARRAY [REAL_64]} << 3,  3,  1,  0 >>
				>>
		end

	singular_matrix: ARRAY [ARRAY [DOUBLE]]
		attribute
			Result :=
				<<
				{ARRAY [REAL_64]} << 1,  1,  1,  2 >>,
				{ARRAY [REAL_64]} << 1,  1,  1,  3 >>,
				{ARRAY [REAL_64]} << 1,  1,  1,  4 >>
				>>
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			system: FUTURE_GAUSS_ELIMINATION
		do
			default_create -- From {TEST_SET_SUPPORT} to set environment.
							-- Allows us to use test-assertion-calls in this code.

			create system.make_from_array (normal_matrix)

			assert_strings_equal_diff ("system_before_solution", system_before_solution + line_ending, system.out)
			system.solve
			assert_strings_equal ("system_solved", system_solved + line_ending, system.out)

		end

feature {NONE} -- Implementation: Test Support

	line_ending: STRING = "%T%N"

--   X	  Y		  Z		 Constant
--  2x	 +y		 -z		=   8
-- -3x	 -y		 2z		= -11
-- -2x	 +y		 2z		=  -3

	system_before_solution: STRING = "[
 2.00	 1.00	-1.00	 8.00	
-3.00	-1.00	 2.00	-11.00	
-2.00	 1.00	 2.00	-3.00
]"

-- X	  Y		  Z		 Constant
-- -3x	 -y		 2z		= -11
-- 		 1.67y	 0.67z	= 4.33
-- 		 		 0.2z	= -0.20

	system_solved: STRING = "[
-3.00	-1.00	 2.00	-11.00	
 0.00	 1.67	 0.67	 4.33	
 0.00	 0.00	 0.20	-0.20
]"

-- We can now solve x,y,zed

--	0.2z	= -0.20 --> [[ z = -0.04 ]]

--	1.67y	 0.67z	= 4.33 --> 1.67y + (0.67 * -0.04) = 4.33
--						   --> 1.67y + -0.0268 = 4.33
--						   --> 1.67y = 0.0268 + 4.33
--						   --> 1.67y = 4.3568
--						   --> y = 4.3568 / 1.67 = ~2.609
--					   	   --> [[ y ~ 2.609 ]]

--	-3x		+2.609	-0.04 = -11 --> -3x +2.569 = -11
--								--> -3x = -11 -2.569 --> -13.569
--								--> x = -13.569 / -3
--								--> [[ x = 4.523 ]]

-- [[ x = 4.523 ]], [[ y ~ 2.609 ]], [[ z = -0.04 ]]

end
