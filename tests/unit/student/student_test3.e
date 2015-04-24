note
	description: "Summary description for {INVENTORY_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST3

	inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent inventory_tests1)
			add_boolean_case (agent inventory_tests2)
			add_boolean_case (agent inventory_tests3)
		end

feature
	inventory_tests1: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invent: STRING
		inv: INVENTORY
		index: INTEGER
	do
		comment("inventory_tests1: creating inventory")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create inv.make (inventory)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end
		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)
	    check Result end

		inv.add_order (<<["foo", 5]>>)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end
		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)

	end

	inventory_tests2: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invent: STRING
		inv: INVENTORY
		index: INTEGER
	do
		comment("inventory_tests2: adding an item to the inventory and test get_stock")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create inv.make (inventory)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end

		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)
	    check Result end

		inv.add_product ("foo", 5)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end

		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)
	end

	inventory_tests3: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invent: STRING
		inv: INVENTORY
		index: INTEGER
	do
		comment("inventory_tests3: removing an item to the inventory and test get_stock")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create inv.make (inventory)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end

		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)
	    check Result end

		inv.add_order (<<["foo", 5]>>)

		create invent.make_empty
		index := 0
		across inventory as it  loop
			index := index + 1
			invent.append (it.item)
			invent.append ("->")
			invent.append_integer (inventory.occurrences (it.item))
			if index < inventory.count then
				invent.append (",")
			end
		end

		invent.append("%N")
		Result := invent.is_equal (inv.get_stock)
	end

end
