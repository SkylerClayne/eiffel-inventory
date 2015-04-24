note
	description: "Summary description for {MY_BAG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG [G -> {HASHABLE, COMPARABLE}]

inherit
	ADT_BAG[G]
	redefine
		make_empty,
		make_from_tupled_array,
		is_nonnegative,
		bag_equal,
		count,
		domain,
		occurrences,
		is_subset_of,
		extend,
		add_all,
		remove,
		remove_all,
		new_cursor
	end
	ITERABLE[G]
--	DEBUG_OUTPUT


create
	make_empty,
	make_from_tupled_array

convert
	make_from_tupled_array ({ attached ARRAY [ attached TUPLE [G, INTEGER_32]]})

feature{NONE} -- creation
	make_empty
		do
			create bag.make (0)
		end

	make_from_tupled_array (a_array: ARRAY [TUPLE [x: G; y: INTEGER]])
		local
			i: INTEGER
		do
			create bag.make (0)
			if a_array.count > 0 then
				from
					i := 1
				until
					i = a_array.count + 1
				loop
					Current.extend (a_array.at (i).x, a_array.at (i).y)
					i := i + 1
				end
			end
		end

feature -- variables
	bag: HASH_TABLE[INTEGER, G]


feature -- creation queries

	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
		local
			i:INTEGER
		do
			Result := (across a_array as it all it.item.y >=0 end)
		end

feature -- bag equality
	bag_equal alias "|=|"(other: like Current): BOOLEAN
		do
			if Current.count = other.count then
				Result := across domain as g all has (g.item) and other.has(g.item) and then occurrences(g.item) = other.occurrences(g.item) end
			end
		end

feature -- queries

	count: INTEGER
		do
			Result := Current.bag.count
		end


	domain: ARRAY[G]
			-- sorted domain of bag
		local
			sorted: SORTED_TWO_WAY_LIST[G]
   		do
   			if Current.count > 0 then
   					create sorted.make
   			from
   				bag.start
   			until
   				bag.after
   			loop
   				sorted.force (bag.key_for_iteration)
   				bag.forth
   			end

   			sorted.sort
   			create Result.make_filled (sorted.at (1), 1, sorted.count)
   			from
   				sorted.start
   			until
   				sorted.after
   			loop
   				Result.put (sorted.item, sorted.index)
   				sorted.forth
   			end
			Result.compare_objects
			else
				create Result.make_empty
   			end
   		end

 	occurrences alias "[]" (key: G): INTEGER
		do
			Result := 0
			if bag.has (key) then
				if attached bag.at (key) as item then
					Result := item
				end
			end
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
		do
			Result := across domain as g all has (g.item) implies other.has(g.item) and then occurrences(g.item) <= other.occurrences(g.item) end
		end

	contains(a_key: G): BOOLEAN
	do
		if Current.bag.has (a_key) then
			Result := True
		else
			Result := False
		end
	end

feature -- commands
	extend  (a_key: G; a_quantity: INTEGER)
	local
		sorted: SORTED_TWO_WAY_LIST[G]
		a_bag: HASH_TABLE[INTEGER, G]
		do
			if Current.bag.has (a_key) then
				Current.bag.at (a_key) := Current.bag.at (a_key) + a_quantity
			else
				Current.bag.put (a_quantity, a_key)
			end

	   			create a_bag.make(0)
			if count > 0 then
		   		create sorted.make
		   		from
		   			bag.start
				until
		   			bag.after
		   		loop
		   			sorted.extend (bag.key_for_iteration)
		   			bag.forth
		   		end

		  		sorted.sort
		   		from
		   			sorted.start
		 		until
		   			sorted.after
		   		loop
		   			if attached sorted.item as it then
		   				a_bag.extend (occurrences(it), it)
		   			end
		   			sorted.forth
		   		end
				bag.compare_objects
			else
				create bag.make(0)
			end

			bag := a_bag.deep_twin

		end

	add_all (other: like Current)
		local
			cursor: MY_BAG_ITERATION_CURSOR [G]
		do
			cursor := other.new_cursor

			across other as it loop
   				if attached it.item as x then
					Current.extend (x, other.bag.at (x))
				end
			end

		end

	remove  (a_key: G; a_quantity: INTEGER)
		do
			if Current.bag.has (a_key) then
				if Current.bag.at (a_key) > a_quantity then
					Current.bag.at (a_key) := Current.bag.at (a_key) - a_quantity
				else
					Current.bag.remove (a_key)
				end
			end
		end

	remove_all (other: like Current)
		local
			cursor: MY_BAG_ITERATION_CURSOR [G]
		do

			across other as it loop
   				if attached it.item as x then
					Current.remove (x, other.bag.at (x))
				end
			end
		end

	new_cursor: MY_BAG_ITERATION_CURSOR [G]
		do
			create Result.make (Current)
			Result.start
		end



end
