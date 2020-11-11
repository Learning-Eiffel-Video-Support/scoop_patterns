note
	description: "[
		Concrete representation of Randomizing features.
		]"
	synopsis: "[
		The features of this class represent various applications
		of having access to a `random_integer' and `random_integer_in_range'.
		From these two features, we can ask for random characters
		from various sets of characters (like A-Z, a-z, and 0-9).
		
		Once a stable random number can be generated on-demand, any
		number of applications can be built (e.g. `random_date_past_90_days').
		These variously applied-random features allow us to construct
		any number of randomized test data, which can be used for
		testing in other venues and use cases.
		]"

class
	RANDOMIZER

feature -- Identifiers

	uuid: UUID
			-- `uuid' of Current (like an ISBN, but stronger).
		do
			create Result.make (random_integer.to_natural_32, random_integer.to_natural_16, random_integer.to_natural_16, random_integer.to_natural_16, random_integer.to_natural_64)
		end

	uuid_hyphenless_string: STRING
		do
			Result := uuid.out
			Result.replace_substring_all ("-", "")
		end

feature -- Random Arrays

	random_array_strings (a_count: INTEGER): ARRAY [STRING]
		local

		do
			create Result.make_filled ("", 1, a_count)
			across
				1 |..| a_count as ic
			loop
				Result.put (random_word, ic.item)
			end
		end

feature -- Random Numbers

	random_range: INTEGER_INTERVAL
		do
			Result := (1 |..| random_number)
		end

	from_1_to (a_number: INTEGER): INTEGER_INTERVAL
		do
			Result := (1 |..| a_number)
		end

	random_real: REAL_64
			-- A new `random_real' based on `random_sequence'.
		do
			Random_sequence.forth
			Result := Random_sequence.double_item
		end

	random_integer,
	random_number: INTEGER
			-- A new `random_integer' based on `random_sequence'.
		do
			random_sequence.forth
			Result := random_sequence.item
		end

	random_integer_in_range (a_range: INTEGER_INTERVAL): INTEGER
			-- A `random_integer_in_range' of `a_range'.
		do
			Result := random_integer \\ (a_range.upper - a_range.lower) + 1 + a_range.lower
		ensure
			in_range: a_range.has (Result)
		end

	random_real_in_range (a_range: INTEGER_INTERVAL): REAL_64
			-- A `random_real_in_range' of `a_range'.
		do
			Result := random_real * (a_range.upper.to_double - a_range.lower.to_double) + a_range.lower.to_double
		ensure
			ranged: (Result >= a_range.lower.to_double) and (Result <= a_range.upper.to_double)
		end

	random_dollars_in_range (a_range: INTEGER_INTERVAL): DECIMAL
		do
			Result := random_decimal_in_range (a_range, 2)
		end

	random_dollars_in_range_3 (a_range: INTEGER_INTERVAL): DECIMAL
		do
			Result := random_decimal_in_range (a_range, 3)
		end

	random_dollars_in_range_4 (a_range: INTEGER_INTERVAL): DECIMAL
		do
			Result := random_decimal_in_range (a_range, 4)
		end

	random_decimal_in_range (a_range: INTEGER_INTERVAL; a_places: INTEGER): DECIMAL
		local
			l_list: LIST [STRING]
		do
			l_list := random_real_in_range (a_range).out.split ('.')
			create Result.make_from_string (l_list [1] + "." + l_list [2].substring (1, a_places))
		end

	unique_array (a_capacity: INTEGER; a_range: INTEGER_INTERVAL): ARRAYED_LIST [INTEGER]
			-- A `unique_array' of `a_capacity' as a list of `random_integer' items.
		local
			l_number, v: INTEGER
		do
			create Result.make (a_capacity)
			across 1 |..| a_capacity as ic loop
				from
					v := a_capacity * 100
					l_number := random_integer \\ (a_range.upper - a_range.lower) + 1 + a_range.lower
				variant
					v
				until
					not Result.has (l_number) or Result.is_empty
				loop
					v := v - 1
					l_number := random_integer \\ (a_range.upper - a_range.lower) + 1 + a_range.lower
				end
				Result.force (l_number)
			end
		ensure
			capacity: Result.count = a_capacity
			unique_content: across Result as ic_list all Result.occurrences (ic_list.item) = 1 end
		end

feature -- Random Boolean

	random_boolean: BOOLEAN
			-- A `random_boolean' value.
		do
			if random_integer_in_range (1 |..| 10) >= 5 then
				Result := True
			end
		end

feature -- Random Date

	random_date_past_30_days: DATE
			-- A `random_date_past_30_days'.
		do
			Result := random_date_in_range (1 |..| 30, True)
		end

	random_date_past_60_days: DATE
			-- A `random_date_past_60_days'.
		do
			Result := random_date_in_range (1 |..| 60, True)
		end

	random_date_past_90_days: DATE
			-- A `random_date_past_90_days'.
		do
			Result := random_date_in_range (1 |..| 90, True)
		end

	random_date_past_90_to_120_days: DATE
			-- A `random_date_past_90_to_120_days'.
		do
			Result := random_date_in_range (90 |..| 120, True)
		end

	in_past: BOOLEAN = True
	in_future: BOOLEAN = False

	random_date_around_now (a_days: INTEGER): DATE
			-- {DATE} from "now" +/- `a_days'.
		do
			Result := random_date_in_future_days (a_days)
			Result.day_add ( (a_days / 2).truncated_to_integer * -1 )
		end

	random_date_in_future_days (a_days: INTEGER): DATE
			-- {DATE} a random `a_days' after "now".
		do
			Result := random_date_in_range (1 |..| a_days, in_future)
		end

	random_date_in_future_range (a_range: INTEGER_INTERVAL): DATE
			-- {DATE} in `a_range' after "now".
		do
			Result := random_date_in_range (a_range, in_future)
		end

	random_date_in_past_days (a_days: INTEGER): DATE
			-- {DATE} a random `a_days' before "now".
		do
			Result := random_date_in_range (1 |..| a_days, in_past)
		end

	random_date_in_past_range (a_range: INTEGER_INTERVAL): DATE
			-- {DATE} in `a_range' before "now".
		do
			Result := random_date_in_range (a_range, in_past)
		end

	random_date_in_range (a_range: INTEGER_INTERVAL; a_in_past: BOOLEAN): DATE
			-- A `random_date_in_range' in `a_range' of number of days ago.
		do
			create Result.make_now
			if a_in_past then
				Result.day_add (random_integer_in_range (a_range) * -1)
			else
				Result.day_add (random_integer_in_range (a_range))
			end
		end

feature -- Random Characters

	random_digit: CHARACTER
			-- A `random_digit' from `digits'.
		do
			Result := Digits [random_integer_in_range (1 |..| Digits.count)]
		ensure
			contains_digit: Digits.has (Result)
		end

	random_a_to_z_lower: CHARACTER
			-- A `random_a_to_z_lower' case.
		do
			Result := Alphabet_lower [random_integer_in_range (1 |..| Alphabet_lower.count)]
		ensure
			contains_lower: Alphabet_lower.has (Result)
		end

	random_a_to_z_upper: CHARACTER
			-- A `random_a_to_z_upper' case.
		do
			Result := random_a_to_z_lower.as_upper
		ensure
			contains_upper: Alphabet_lower.has (Result.as_lower)
		end

	random_character_from_string (a_string: STRING): CHARACTER
			-- A `random_character_from_string'.
		do
			Result := a_string [random_integer_in_range (1 |..| a_string.count)]
		ensure
			in_string: a_string.has (Result)
		end

feature -- Random Strings

	random_schedule_spec_unbounded: STRING
			-- Example: "<><JAN-DEC><MON-FRI><0800-1700><>"
			-- Unbounded having no start or end date boundaries
		do
			create Result.make_empty
			Result := "<>" + "<" + random_month_name_range + "><" + random_day_name_range + "><" + random_hours_range + "><>"
		end

	hours_list: ARRAY [STRING]
		once
			Result := <<"0000","0100","0200","0300","0400","0500","0600","0700","0800","0900","1000","1100","1200","1300","1400","1500","1600","1700","1800","1900","2000","2100","2200","2300">>
		end

	random_hour: STRING
		do
			Result := random_string_from_list (1, 24, hours_list)
		end

	random_hours_range: STRING
		do
			Result := random_string_from_list (1, 12, hours_list) + "-" + random_string_from_list (13, 24, hours_list)
		end

	random_day_name: STRING
		do
			Result := random_string_from_list (1, 7, day_names)
		end

	random_day_name_range: STRING
		do
			Result := random_string_from_list (1, 4, day_names) + "-" + random_string_from_list (5, 6, day_names)
		end

	day_names: ARRAY [STRING]
		once
			Result := <<"SUN","MON","TUE","WED","THU","FRI","SAT">>
		ensure
			Result.count = 7
		end

	random_month_name: STRING
		do
			Result := random_string_from_list (1, 12, month_names)
		end

	random_month_name_range: STRING
		do
			Result := random_string_from_list (1, 6, month_names) + "-" + random_string_from_list (7, 12, month_names)
		end

	month_names: ARRAY [STRING]
		once
			Result := <<"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC">>
		ensure
			Result.count = 12
		end

	random_string_from_list (a_start, a_end: INTEGER; a_list: ARRAY [STRING]): STRING
		require
			positive: a_start > 0 and a_end > 0
			in_range: a_start <= a_list.count and a_end <= a_list.count
			left_to_right: a_start < a_end
		local
			l_rnd: INTEGER
		do
			l_rnd := random_integer_in_range (a_start |..| a_end)
			Result := a_list [l_rnd]
		end

	random_uom: STRING
		do
			Result := uoms [random_integer_in_range (from_1_to (uoms.count))]
		end

	random_material_type_subtype: STRING
		do
			Result := material_type_subtypes [random_integer_in_range (from_1_to (material_type_subtypes.count))]
		end

	material_type_subtypes: ARRAYED_LIST [STRING]
		do
			create Result.make (1_000)
			Result.force("Wood")
			Result.force("Wood:Rough Carpentry")
			Result.force("Wood:Rough Carpentry:Heavy Timbers")
			Result.force("Wood:Rough Carpentry:Log Home")
			Result.force("Wood:Rough Carpentry:Timber Framing")
			Result.force("Wood:Rough Carpentry:Post and Beam")
			Result.force("Wood:Rough Carpentry:Bamboo")
			Result.force("Wood:Rough Carpentry:Engineered Wood")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber:Stud")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber:Joist")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber:Rafter")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber:Treated")
			Result.force("Wood:Rough Carpentry:Dimensional Lumber:Decking")
			Result.force("Wood:Rough Carpentry:Sheathing")
			Result.force("Wood:Rough Carpentry:Sheathing:Plywood")
			Result.force("Wood:Rough Carpentry:Sheathing:Shiplap")
			Result.force("Wood:Rough Carpentry:Sheathing:Tongue and Groove")
			Result.force("Wood:Rough Carpentry:Sheathing:Oriented Strand Board")
			Result.force("Wood:Rough Carpentry:Subflooring")
			Result.force("Wood:Rough Carpentry:Paneling")
			Result.force("Wood:Rough Carpentry:Parallel Strand Lumber")
			Result.force("Wood:Rough Carpentry:Glue-laminate")
			Result.force("Wood:Finish Carpentry")
			Result.force("Wood:Finish Carpentry:Veneer")
			Result.force("Wood:Finish Carpentry:Plastic Laminate")
			Result.force("Wood:Finish Carpentry:Wood Panel")
			Result.force("Wood:Finish Carpentry:Case-building Products")
			Result.force("Wood:Finish Carpentry:Case-building Products:Millwork")
			Result.force("Wood:Finish Carpentry:Case-building Products:Bookcase")
			Result.force("Wood:Finish Carpentry:Case-building Products:Cabinets")
			Result.force("Wood:Finish Carpentry:Ornamental Woodwork")
			Result.force("Wood:Finish Carpentry:Trim")
			Result.force("Wood:Finish Carpentry:Moulding")
			Result.force("Wood:Finish Carpentry:Moulding:Chair Rail")
			Result.force("Wood:Finish Carpentry:Moulding: Baseboard")
			Result.force("Wood:Finish Carpentry:Moulding: Casing")
			Result.force("Wood:Finish Carpentry:Moulding: Sill")
			Result.force("Windows")
			Result.force("Windows:Casement")
			Result.force("Windows:Double-hung")
			Result.force("Windows:Bay")
			Result.force("Windows:Curtainwall")
			Result.force("Windows:Skylight")
			Result.force("Windows:Dormer")
		end

	random_job_type_subtype: STRING
		do
			Result := job_type_subtypes [random_integer_in_range (from_1_to (job_type_subtypes.count))]
		end

	job_type_subtypes: ARRAYED_LIST [STRING]
		do
			create Result.make (1_000)
			Result.force ("Airline")
			Result.force ("Airline:Aircraft Dispatcher")
			Result.force ("Airline:Aircraft Mechanic")
			Result.force ("Airline:Airline Pilot")
			Result.force ("Airline:Flight Attendant")
			Result.force ("Arts")
			Result.force ("Arts:Actor")
			Result.force ("Arts:Architecture")
			Result.force ("Arts:Art Appraiser")
			Result.force ("Arts:Art Auctioneer")
			Result.force ("Arts:Artist")
			Result.force ("Arts:Museum Jobs")
			Result.force ("Arts:Music Conductor")
			Result.force ("Business")
			Result.force ("Business:Accountant")
			Result.force ("Business:Administrative Assistant/Secretary")
			Result.force ("Business:Advertising")
			Result.force ("Business:Consultant")
			Result.force ("Business:Financial Advisor")
			Result.force ("Business:Fundraiser")
			Result.force ("Business:Government Jobs")
			Result.force ("Business:Human Resources")
			Result.force ("Business:Insurance Agent")
			Result.force ("Business:Investment Banker")
			Result.force ("Business:Lawyer")
			Result.force ("Business:Management")
			Result.force ("Business:Market Research Analyst")
			Result.force ("Business:Nonprofit Job")
			Result.force ("Business:Law Enforcement")
			Result.force ("Criminal Justice")
			Result.force ("Criminal Justice:Federal Law Enforcement")
			Result.force ("Criminal Justice:Police Officer")
			Result.force ("Criminal Justice:Media")
			Result.force ("Book Publishing")
			Result.force ("Book Publishing:Freelance Editor")
			Result.force ("Book Publishing:Book Publishing:Freelance Writer")
			Result.force ("Book Publishing:Public Relations")
			Result.force ("Book Publishing:Web Developer")
			Result.force ("Book Publishing:Writer/Editor")
			Result.force ("Medical")
			Result.force ("Medical:Doctor")
			Result.force ("Medical:Nurse")
			Result.force ("Medical:Paramedic")
			Result.force ("Medical:Psychologist")
			Result.force ("Medical:Social Worker")
			Result.force ("Medical:Veterinarian")
			Result.force ("Service Industry")
			Result.force ("Service Industry:Bank Teller")
			Result.force ("Service Industry:Call Center")
			Result.force ("Service Industry:Funeral Director")
			Result.force ("Service Industry:Hair Stylist")
			Result.force ("Service Industry:Personal Fitness Trainer")
			Result.force ("Service Industry:Retail")
			Result.force ("Service Industry:Sales")
			Result.force ("Service Industry:Ski Instructor")
			Result.force ("Service Industry:Waiter")
			Result.force ("Service Industry:Wedding Planner")
			Result.force ("Teaching")
			Result.force ("Teaching:Career Counselor")
			Result.force ("Teaching:School Jobs")
			Result.force ("Teaching:Substitute Teacher")
			Result.force ("Teaching:Teacher")
			Result.force ("Teaching:Teaching Abroad")
			Result.force ("Teaching:Teaching Online")
			Result.force ("Technology")
			Result.force ("Technology:App Developer")
			Result.force ("Technology:Computer Programmer")
			Result.force ("Technology:Database Administrator")
			Result.force ("Technology:Programmer")
			Result.force ("Technology:Software Developer")
			Result.force ("Technology:Web Developer")
			Result.force ("Other")
			Result.force ("Other:Animal Careers")
			Result.force ("Other:Military Careers")
			Result.force ("Other:STEM Careers")
		end

	random_paragraph: STRING
			-- A `random_paragraph' made up of `random_sentence' items.
		do
			create Result.make_empty
			across
				1 |..| random_integer_in_range (2 |..| 6) as al_word_count
			loop
				Result.append_string (random_sentence)
				Result.append_character (' ')
			end
			Result.remove_tail (1)
		end

	random_sentence: STRING
			-- A `random_sentence' made up of `random_word' items.
		do
			create Result.make_empty
			across
				1 |..| random_integer_in_range (2 |..| 6) as al_word_count
			loop
				Result.append_string (random_word)
				Result.append_character (' ')
			end
			Result.remove_tail (1)
			Result.append_character ('.')
			Result := Result [1].as_upper.out + Result.substring (2, Result.count)
		end

	random_identifier: STRING
		do
			Result := random_word
			Result.replace_substring_all (" ", "_")
			Result.append_string (random_integer.out)
		end

	random_word: STRING
			-- A `random_word'.
		do
			create Result.make_empty
			across
				1 |..| random_integer_in_range (2 |..| 3) as al_syllable_count
			loop
				inspect
					random_integer_in_range (1 |..| 2)
				when 1 then -- <v><c> 	like "em" or "um"
					Result.append_string (random_vowel_grapheme)
					Result.append_string (random_multiple_consonent_grapheme)
				when 2 then -- <c><v> 	like "me" or "mu"
					Result.append_string (random_single_consonent_grapheme)
					Result.append_string (random_vowel_grapheme)
				end
			end
		end

	random_single_consonent_grapheme: STRING
			-- A `random_single_consonent_grapheme'from `Alpha_consonents'
		do
			Result := Alpha_consonents [random_integer_in_range (1 |..| Alpha_consonents.count)].out
		end

	random_multiple_consonent_grapheme: STRING
			-- A `random_multiple_consonent_grapheme' based on 18 consonent variants.
		note
			material: "[
				Consonants

				Sound #	Sound	Graphemes	Examples
				1	/b/	b, bb	bug, bubble
				2	/d/	d, dd, ed	dad, add, milled
				3	/f/	f, ff, ph, gh, lf, ft	fat, cliff, phone, enough, half, often
				4	/g/	g, gg, gh,gu,gue	gun, egg, ghost, guest, prologue
				5	/h/	h, wh	hop, who
				6	/j/	j, ge, g, dge, di, gg	jam, wage, giraffe, edge, soldier, exaggerate
				7	/k/	k, c, ch, cc, lk, qu ,q(u), ck, x	kit, cat, chris, accent, folk, bouquet, queen, rack, box
				8	/l/	l, ll	live, well
				9	/m/	m, mm, mb, mn, lm	man, summer, comb, column, palm
				10	/n/	n, nn,kn, gn, pn	net, funny, know, gnat, pneumonic
				11	/p/	p, pp	pin, dippy
				12	/r/	r, rr, wr, rh	run, carrot, wrench, rhyme
				13	/s/	s, ss, c, sc, ps, st, ce, se	sit, less, circle, scene, psycho, listen, pace, course
				14	/t/	t, tt, th, ed	tip, matter, thomas, ripped
				15	/v/	v, f, ph, ve	vine, of, stephen, five
				16	/w/	w, wh, u, o	wit, why, quick, choir
				17	/y/	y, i, j	yes, onion, hallelujah
				18	/z/	z, zz, s, ss, x, ze, se	zed, buzz, his, scissors, xylophone, craze
			]"
		do
			create Result.make_empty
			inspect
				random_integer_in_range (1 |..| 44)
			when 1 then --bb
				Result := "bb"
			when 2 then --cc
				Result := "cc"
			when 3 then --ce
				Result := "ce"
			when 4 then --ch
				Result := "ch"
			when 5 then --ck
				Result := "ck"
			when 6 then --dd
				Result := "dd"
			when 7 then --dge
				Result := "dge"
			when 8 then --di
				Result := "di"
			when 9 then --ed
				Result := "ed"
			when 10 then --ff
				Result := "ff"
			when 11 then --ft
				Result := "ft"
			when 12 then --ge
				Result := "ge"
			when 13 then --gg
				Result := "gg"
			when 14 then --gh
				Result := "gh"
			when 15 then --gn
				Result := "gn"
			when 16 then --gu
				Result := "gu"
			when 17 then --gue
				Result := "gue"
			when 18 then --kn
				Result := "kn"
			when 19 then --lf
				Result := "lf"
			when 20 then --lk
				Result := "lk"
			when 21 then --ll
				Result := "ll"
			when 22 then --lm
				Result := "lm"
			when 23 then --mb
				Result := "mb"
			when 24 then --mm
				Result := "mm"
			when 25 then --mn
				Result := "mn"
			when 26 then --nn
				Result := "nn"
			when 27 then --ph
				Result := "ph"
			when 28 then --pn
				Result := "pn"
			when 29 then --pp
				Result := "pp"
			when 30 then --ps
				Result := "ps"
			when 31 then --qu
				Result := "qu"
			when 32 then --rh
				Result := "rh"
			when 33 then --rr
				Result := "rr"
			when 34 then --sc
				Result := "sc"
			when 35 then --se
				Result := "se"
			when 36 then --ss
				Result := "ss"
			when 37 then --st
				Result := "st"
			when 38 then --th
				Result := "th"
			when 39 then --tt
				Result := "tt"
			when 40 then --ve
				Result := "ve"
			when 41 then --wh
				Result := "wh"
			when 42 then --wr
				Result := "wr"
			when 43 then --ze
				Result := "ze"
			when 44 then --zz
				Result := "zz"
			end
		end

	random_vowel_grapheme: STRING
			-- A `random_vowel_grapheme' based on 14 vowel graphemes
		note
			vowels: "[
				Vowels

				Sound#	Sound	Graphemes	Examples
				19	/a/	a, ai, au	cat, plaid, laugh
				20	/ā/	a, ai, eigh, aigh, ay, er, et, ei, au, a_e, ea, ey	bay, maid, weigh, straight, pay, foyer, filet, eight, gauge, mate, break, they
				21	/e/	e, ea, u, ie, ai, a, eo, ei, ae, ay	end, bread, bury, friend, said, many, leopard, heifer, aesthetic, say
				22	/ē/	e, ee, ea, y, ey, oe, ie, i, ei, eo, ay	be, bee, meat, lady, key, phoenix, grief, ski, deceive, people, quay
				23	/i/	i, e, o, u, ui, y, ie	it, england, women, busy, guild, gym, sieve
				24	/ī/	i, y, igh, ie, uy, ye, ai, is, eigh, i_e	spider, sky, night, pie, guy, stye, aisle, island, height, kite
				25	/o/	o, a, ho, au, aw, ough	octopus, swan, honest, maul, slaw, fought
				26	/ō/	o, oa, o_e, oe, ow, ough, eau, oo, ew	open, moat, bone, toe, sow, dough, beau, brooch, sew
				27	/oo/	o, oo, u,ou	wolf, look, bush, would
				28	/u/	u, o, oo, ou	lug, monkey, blood, double
				29	/ū/	o, oo, ew, ue, u_e, oe, ough, ui, oew, ou	who, loon, dew, blue, flute, shoe, through, fruit, manoeuvre, group
				30	/y//ü/	u, you, ew, iew, yu, ul, eue, eau, ieu, eu	unit, you, knew, view, yule, mule, queue, beauty, adieu, feud
				31	/oi/	oi, oy, uoy	join, boy, buoy
				32	/ow/	ow, ou, ough	now, shout, bough
				33	/ə/ (schwa)	a, er, i, ar, our, or, e, ur, re, eur	about, ladder, pencil, dollar, honour, doctor, ticket, augur, centre, chauffeur
				]"
		do
			create Result.make_empty
			inspect
				random_integer_in_range (1 |..| 52)
			when 1 then --a
				Result := "a"
			when 2 then --ae
				Result := "ae"
			when 3 then --ai
				Result := "ai"
			when 4 then --aigh
				Result := "aigh"
			when 5 then --ar
				Result := "ar"
			when 6 then --au
				Result := "au"
			when 7 then --aw
				Result := "aw"
			when 8 then --ay
				Result := "ay"
			when 9 then --e
				Result := "e"
			when 10 then --ea
				Result := "ea"
			when 11 then --eau
				Result := "eau"
			when 12 then --ee
				Result := "ee"
			when 13 then --ei
				Result := "ei"
			when 14 then --eigh
				Result := "eigh"
			when 15 then --eo
				Result := "eo"
			when 16 then --er
				Result := "er"
			when 17 then --et
				Result := "et"
			when 18 then --eu
				Result := "eu"
			when 19 then --eue
				Result := "eue"
			when 20 then --eur
				Result := ""
			when 21 then --ew
				Result := "ew"
			when 22 then --ey
				Result := "ey"
			when 23 then --ho
				Result := "ho"
			when 24 then --i
				Result := "i"
			when 25 then --ie
				Result := "ie"
			when 26 then --ieu
				Result := "ieu"
			when 27 then --iew
				Result := "iew"
			when 28 then --igh
				Result := "igh"
			when 29 then --is
				Result := "is"
			when 30 then --o
				Result := "o"
			when 31 then --oa
				Result := "oa"
			when 32 then --oe
				Result := "oe"
			when 33 then --oew
				Result := "oew"
			when 34 then --oi
				Result := "oi"
			when 35 then --oo
				Result := "oo"
			when 36 then --or
				Result := "or"
			when 37 then --ou
				Result := "ou"
			when 38 then --ough	
				Result := "ough"
			when 39 then --our
				Result := "our"
			when 40 then --ow
				Result := "ow"
			when 41 then --oy
				Result := "oy"
			when 42 then --re
				Result := "re"
			when 43 then --u
				Result := "u"
			when 44 then --ue
				Result := "ue"
			when 45 then --ul
				Result := "ul"
			when 46 then --uoy
				Result := "uoy"
			when 47 then --ur
				Result := "ur"
			when 48 then --uy
				Result := "uy"
			when 49 then --y
				Result := "y"
			when 50 then --ye
				Result := "ye"
			when 51 then --you
				Result := "you"
			when 52 then --yu
				Result := "yu"
			end
		end

feature -- Random PID

	random_first_last_name: STRING
			-- A `random_first_last_name' from `First_names' and `Last_names'.
		note
			dependency: "[
				This feature has a data source file dependecy that must be met!
				]"
		do
			Result := random_first_name
			Result.append_character (' ')
			Result.append_string (random_last_name)
		end

	random_last_first_name: STRING
			-- A `random_last_first_name' from `Last_names' and `First_names'.
		note
			dependency: "[
				This feature has a data source file dependecy that must be met!
				]"
		do
			Result := random_last_name
			Result.append_character (',')
			Result.append_character (' ')
			Result.append_string (random_first_name)
		end

	random_first_name: STRING
			-- A `random_first_name' from a `First_names' list.
		note
			dependency: "[
				This feature has a data source file dependecy that must be met!
				]"
		do
			Result := First_names [random_integer_in_range (1 |..| First_names.count)]
		end

	random_last_name: STRING
			-- A `random_last_name' from a `Last_names' list.
		note
			dependency: "[
				This feature has a data source file dependecy that must be met!
				]"
		do
			Result := Last_names [random_integer_in_range (1 |..| Last_names.count)]
		end

	random_social_security_number: STRING
			-- A `random_social_security_number'.
		do
			Result := random_integer_in_range (111 |..| 999).out
			Result.append_character ('-')
			Result := random_integer_in_range (11 |..| 99).out
			Result.append_character ('-')
			Result := random_integer_in_range (1111 |..| 9999).out
		end

	random_formatted_phone_number: STRING
			-- A `random_phone_number' as "(999) 999-9999".
		do
			Result := random_integer_in_range (111 |..| 999).out
			Result.prepend_character ('(')
			Result.append_character (')')
			Result.append_character (' ')
			Result := random_integer_in_range (111 |..| 999).out
			Result.append_character ('-')
			Result := random_integer_in_range (1111 |..| 9999).out
		end

	random_pan: STRING
			-- A `random_pan', where PAN is Primary Account Number.
		do
			Result := random_integer_in_range (1_111_111 |..| 9_999_999).out
		end

	random_coded_pan: STRING
			-- A `random_coded_pan'.
		do
			Result := random_word
			Result.append_string (random_pan)
		end

feature -- Random Addresses

	random_address: STRING
		do
			Result := random_integer_in_range (1000 |..| 9999).out					-- Street Number
			Result.append_character (' ')
			Result.append_string (random_word.as_upper)								-- Street name
			Result.append_character (' ')
			Result.append_string (random_street_suffix.as_upper)					-- Street Suffix
			Result.append_character ('%N')
			Result.append_string (random_city_name.as_upper)						-- City name
			Result.append_character (',')
			Result.append_character (' ')
			Result.append_string (random_state_code)								-- State code
			Result.append_character (' ')
			Result.append_character (' ')
			Result.append_string (random_integer_in_range (11111 |..| 99999).out)	-- ZIP Code
		end

	random_address_tuple: TUPLE [street, name, suffix, city, state, zip: STRING]
		do
			Result := [
						random_integer_in_range (1000 |..| 9999).out,
						random_word.as_upper,
						random_street_suffix.as_upper,
						random_city_name.as_upper,
						random_state_code,
						random_integer_in_range (11111 |..| 99999).out
						]
		end

	random_address_hash: HASH_TABLE [like random_address_tuple, UUID]
		local
			l_capacity: INTEGER
		do
			l_capacity := random_integer_in_range (1_000 |..| 2_000)
			create Result.make (l_capacity)
			across
				(1 |..| l_capacity) as ic
			loop
				Result.force (random_address_tuple, uuid)
			end
		end

	random_addresses_as_array (a_range: INTEGER_INTERVAL): ARRAY [like random_address_tuple]
		local
			l_capacity: INTEGER
			l_array: ARRAYED_LIST [like random_address_tuple]
		do
			l_capacity := random_integer_in_range (a_range)
			create l_array.make (l_capacity)
			across
				(1 |..| l_capacity) as ic
			loop
				l_array.force (random_address_tuple)
			end
			Result := l_array.to_array
		end

	random_state_code: STRING
		local
			l_list: LIST [STRING]
		do
			l_list := state_codes.split ('%N')
			Result := l_list [random_integer_in_range (1 |..| l_list.count)]
		end

	random_city_name: STRING
		local
			l_list: LIST [STRING]
		do
			l_list := city_suffixes.split ('%N')
			Result := random_word
			Result.append_string (l_list [random_integer_in_range (1 |..| l_list.count)])
		end

	random_world_city: TUPLE [country, city, accentcity, region, population, latitude, longitude: STRING]
		do
			Result := World_cities [random_integer_in_range (from_1_to (World_cities.count))]
		end

	random_occupation: STRING
		do
			Result := Occupations [random_integer_in_range (from_1_to (Occupations.count))]
		end

	random_street_suffix: STRING
		local
			l_list: LIST [STRING]
		do
			l_list := street_suffixes.split ('%N')
			Result := l_list [random_integer_in_range (1 |..| l_list.count)]
		end

feature -- Randoms with Exceptions

	random_digit_with_exceptions (a_exceptions: STRING): CHARACTER
			-- A `random_digit_with_exceptions' found in `a_exceptions'.
		do
			Result := random_with_exceptions (a_exceptions, Digits)
		ensure
			no_exceptions: not a_exceptions.has (Result)
		end

	random_a_to_z_with_exceptions (a_exceptions: STRING): CHARACTER
			-- A `random_a_to_z_with_exceptions' found in `a_exceptions'.
		do
			Result := random_with_exceptions (a_exceptions, Alphabet_lower)
		ensure
			no_exceptions: not a_exceptions.has (Result)
		end

	random_a_to_z_upper_with_exceptions (a_exceptions: STRING): CHARACTER
			-- A `random_a_to_z_upper_with_exceptions' found in `a_exceptions'.
		do
			Result := random_with_exceptions (a_exceptions, Alphabet_lower.as_upper)
		ensure
			no_exceptions: not a_exceptions.has (Result)
		end

	random_with_exceptions (a_exceptions, a_string: STRING): CHARACTER
			-- A `random_with_exceptions' based on `a_exceptions' from `a_string'.
		require
			has_exceptions: not a_exceptions.is_empty
			exceptions_in_string: across a_exceptions as ic_exception all a_string.has (ic_exception.item) end
		do
			from Result := a_exceptions [1] until not a_exceptions.has (Result)
			loop
				Result := a_string [random_integer_in_range (1 |..| a_string.count)]
			end
		ensure
			no_exceptions: not a_exceptions.has (Result)
		end

feature {NONE} -- Implementation

	random_sequence: RANDOM
			-- Random sequence
		local
			l_time: TIME
			l_seed: INTEGER
		once ("object")
				-- This computes milliseconds since midnight.
			create l_time.make_now
			l_seed := l_time.hour
			l_seed := l_seed * 60 + l_time.minute
			l_seed := l_seed * 60 + l_time.second
			l_seed := l_seed * 1000 + l_time.milli_second
			create Result.set_seed (l_seed)
		end

feature -- Constants

	alphabet_lower: STRING = "abcdefghijklmnopqrstuvwxyz"

	alpha_vowels: STRING = "aeiouy"

	alpha_consonents: STRING = "bcdfghjklmnpqrstvwxz"

	digits: STRING = "0123456789"

	street_suffixes: STRING = "[
ALLEE
ALLY
ANNEX
ANNX
AV
AVEN
AVENU
AVN
AVNUE
BAYOO
BG
BGS
BLFS
BLUF
BOT
BOTTM
BOUL
BOULV
BRDGE
BRKS
BRNCH
BYPA
BYPAS
BYPS
BYU
CANYN
CAUSWA
CEN
CENT
CENTR
CENTRE
CIRC
CIRCL
CIRS
CMN
CMNS
CMP
CNTER
CNTR
CNYN
CRCL
CRCLE
CRSENT
CRSNT
CRSSNG
CRST
CTRS
CURV
CVS
CYN
DIV
DRIV
DRS
DRV
DVD
EXP
EXPR
EXPRESS
EXPW
EXTENSIONS
EXTN
EXTNSN
FORESTS
FORG
FRDS
FREEWY
FRGS
FRRY
FRT
FRWAY
FRWY
GARDN
GATEWY
GATWAY
GDN
GLNS
GRDEN
GRDN
GRDNS
GRNS
GROV
GRVS
GTWAY
HARB
HARBR
HBRS
HEIGHTS
HIGHWY
HIWAY
HIWY
HLLW
HOLLOWS
HOLWS
HRBOR
HT
HWAY
INLET
ISLES
ISLND
ISLNDS
JCTION
JCTN
JCTNS
JUNCTN
JUNCTON
KNOL
LDGE
LGTS
LNDNG
LODG
LOOPS
MEDOWS
MISSION
MISSN
ML
MLS
MNT
MNTAIN
MNTN
MNTNS
MOUNTIN
MSN
MSSN
MTIN
MTNS
MTWY
OPAS
ORCHRD
OVL
PARKWY
PATHS
PIKES
PKWAY
PKWYS
PKY
PLACE
PLZA
PNE
PRK
PRR
PSGE
RAD
RADIEL
RANCHES
RDGE
RIVR
RNCHS
RTE
RVR
SHOAR
SHOARS
SKWY
SPNG
SPNGS
SPRNG
SPRNGS
SQR
SQRE
SQRS
SQS
SQU
STATN
STN
STR
STRAV
STRAVEN
STRAVN
STREME
STRT
STRVN
STRVNUE
STS
SUMIT
SUMITT
TERR
TPKE
TRACES
TRACKS
TRAILS
TRFY
TRK
TRKS
TRLRS
TRLS
TRNPK
TRWY
TUNEL
TUNLS
TUNNELS
TUNNL
TURNPK
UNS
UPAS
VALLY
VDCT
VIADCT
VILL
VILLAG
VILLG
VILLIAGE
VIST
VLLY
VST
VSTA
WL
WY
XRD
XRDS
]"

	city_suffixes: STRING = "[
polis
ville
ford
furt
forth
shire
berg
burg
borough
brough
field
kirk
bury
stadt
]"

	state_codes: STRING = "[
AL
AK
AZ
AR
CA
CO
CT
DE
FL
GA
HI
ID
IL
IN
IA
KS
KY
LA
ME
MD
MA
MI
MN
MS
MO
MT
NE
NV
NH
NJ
NM
NY
NC
ND
OH
OK
OR
PA
RI
SC
SD
TN
TX
UT
VT
VA
WA
WV
WI
WY
DC
PR
VI
AS
GU
MP
AA
AE
AP
]"

	first_names: ARRAYED_LIST [STRING]
		local
			l_file: RAW_FILE
			l_content: STRING
			l_list: LIST [STRING]
		once
			create l_file.make_open_read ("./data/CSV_Database_of_First_Names.csv")
			l_file.read_stream (l_file.count)
			l_content := l_file.last_string
			l_file.close
			l_list := l_content.split ('%R')
			create Result.make (l_list.count)
			across l_list as ic_list loop Result.force (ic_list.item) end
		end

	last_names: ARRAYED_LIST [STRING]
		local
			l_file: RAW_FILE
			l_content: STRING
			l_list: LIST [STRING]
		once
			create l_file.make_open_read ("./data/CSV_Database_of_Last_Names.csv")
			l_file.read_stream (l_file.count)
			l_content := l_file.last_string
			l_file.close
			l_list := l_content.split ('%R')
			create Result.make (l_list.count)
			across l_list as ic_list loop Result.force (ic_list.item) end
		end

	World_cities: ARRAYED_LIST [TUPLE [country, city, accentcity, region, population, latitude, longitude: STRING]]
			--Country,City,AccentCity,Region,Population,Latitude,Longitude
			--ad,aixas,Aixàs,06,,42.4833333,1.4666667
			--ad,aixirivali,Aixirivali,06,,42.4666667,1.5
			--ad,aixirivall,Aixirivall,06,,42.4666667,1.5		
		local
			l_file: RAW_FILE
			l_content: STRING
			l_list,
			l_line: LIST [STRING]
		once
			create Result.make (100_000)
			create l_file.make_open_read ("./data/worldcitiespop.txt")
			l_file.read_stream (l_file.count)
			l_content := l_file.last_string
			l_file.close
			l_content.replace_substring_all ("%R", "")
			l_list := l_content.split ('%N')
			across
				l_list as ic_list
			loop
				l_line := ic_list.item.split (',')
				if ic_list.cursor_index > 1 then
					Result.force ([ l_line [1], l_line [2], l_line [3], l_line [4], l_line [5], l_line [6], l_line [7] ])
				end
			end
		end

	Occupations: ARRAYED_LIST [STRING]
		local
			l_file: RAW_FILE
			l_content: STRING
			l_list: LIST [STRING]
		once
			create Result.make (2_000)
			create l_file.make_open_read ("./data/occupations.txt")
			l_file.read_stream (l_file.count)
			l_content := l_file.last_string
			l_file.close
			l_content.replace_substring_all ("%R", "")
			l_list := l_content.split ('%N')
			across
				l_list as ic_list
			loop
				Result.force (ic_list.item)
			end
		end

	uoms: ARRAYED_LIST [STRING]
		local
			l_list: LIST [STRING]
		once
			l_list := uom_data.split ('%N')
			create Result.make (l_list.count)
			across
				l_list as ic
			loop
				Result.force (ic.item)
			end
		end

	uom_data: STRING = "[
ANGSTROM
ATTOMETER
BIT
BRONTOBYTE
BYTE
CARAT
CENTIMETER
CHAIN
CORUSCANT STANDARD CARAT
CUBIC CENTIMETER
CUBIC KILOMETER
CUBIC KILOMETER
CUBIC METER
CUBIC METER
CUBIT
DAY 
DECADE
DECAMETER 
DECIMETER
DEGREE 
DEGREE STANDARD
EACH
ENERGY UNIT
EXABYTE
EXAMETER
EXAPARSEC
FATHOM
FEMTOMETER
FOOT 
FURLONG
GALLON
GEOPBYTE
G-FORCE 
G-FORCE
GIGABYTE
GIGAMETER
GIGAPARSEC
GIGATON 
GIGAWATT
GLEKK
GRAM
GRIMNAL
HECTARE
HECTOMETER
HOUR
IMPERIAL MINUTE
INCH
JOTABYTE
JOULE
KET
KILOBYTE
KILOGRAM
KILOMETER 
KILOMETER PER HOUR 
KILOPARSEC
KLEKKET 
KTU
KUBA 
LIGHT YEAR
LINE
LINEAR FOOT
LINEAR YARD
LITRE
MEGABYTE
MEGAJOULE 
MEGALIGHT
MEGAMETER
MEGAPARSEC
MEGATOME
METER 
METRIC TON 
MICROGRAM
MICROHERTZ
MICROMETER
MICROSECOND
MILE
MILE PER HOUR 
MILLENNIUM
MILLIBAR
MILLIGRAM
MILLIMETER 
MINUTE 
MYRIAMETER 
MYRIOMETER
NANOMETER
NANOSECOND
NIBBLE
PARSEC 
PETABYTE
PETAMETER
PETAPARSEC
PHONOKA
PICOMETER
PINT
PLANCK LENGTH 
PLANCKTIME 
POINT
POUND
POWER UNIT
PROGRESSION
ROD
RU
SAGABYTE
SALT PAN 
SANGEN
SBD
SECOND
SIRIOMETER
SQUARE FOOT
SQUARE YARD
STANDARD CENTURY
STANDARD MONTH 
STANDARD WEEK
STANDARD YEAR
STRONG-STROKE
SUBLIGHT UNIT 
TERABYTE
TERAHERTZ
TERAMETER
TERAPARSEC
TROGAN METER 
VISVIA 
WATT 
WATT
YARD
YOCTOMETER
YOTTABYTE
YOTTAMETER
YOTTAPARSEC
ZEPTOMETER
ZETAPARSEC
ZETTABYTE
ZETTAMETER
]"

end
