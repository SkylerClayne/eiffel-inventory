note
	description: "Summary description for {ORDER_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST1

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_violation_case (agent order_tests1)
			add_boolean_case (agent order_tests2)
			add_boolean_case (agent order_tests3)
			add_boolean_case (agent order_tests4)
		end

feature
	order_tests1
	local
		order: ORDER
		bag: MY_BAG[STRING]
	do
		comment("order_tests1: must be positive id")
		create bag.make_empty
		create order.make (-1, bag)
	end

	order_tests2: BOOLEAN
	local
		order: ORDER
		bag: MY_BAG[STRING]
	do
		comment("order_tests2: check pending at creation")
		create bag.make_empty
		create order.make (1, bag)
		Result := order.get_state.is_equal ("pending")
	end

	order_tests3: BOOLEAN
	local
		order: ORDER
		bag: MY_BAG[STRING]
	do
		comment("order_tests3: check invoicing an order")
		create bag.make_empty
		create order.make (1, bag)
		order.invoice
		Result := order.get_state.is_equal ("invoiced")
	end

	order_tests4: BOOLEAN
	local
		order: ORDER
		bag: MY_BAG[STRING]
		invoice: STRING
	do
		comment("order_tests4: check the order")
		create bag.make_from_tupled_array (<<["foo", 3], ["bar", 5]>>)
		create order.make (1, bag)
		create invoice.make_from_string ("bar->5,foo->3")
		Result := order.get_order.is_equal (invoice)
	end
end
