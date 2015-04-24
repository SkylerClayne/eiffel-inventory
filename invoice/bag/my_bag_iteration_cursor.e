note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR[G -> {HASHABLE, COMPARABLE}]

inherit
	ITERATION_CURSOR[G]



create
	make

feature {NONE}


	make (my_bag: MY_BAG[G])
	do
		create a_bag.make (0)
		a_bag := my_bag.bag.deep_twin

	end
feature -- variables
	a_bag: HASH_TABLE[INTEGER, G]

feature -- Access

	item: G
		do
			check not after then
				Result := a_bag.key_for_iteration
			end
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			Result := a_bag.after
		end

feature -- Cursor movement

	forth
		do
			check not Current.after then
				a_bag.forth
			end
		end

feature
	start
	do
		a_bag.start

	end



end
