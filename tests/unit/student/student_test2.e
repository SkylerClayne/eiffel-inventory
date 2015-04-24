note
	description: "Summary description for {INVOICES_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST2

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent invoice_test1)
			add_boolean_case (agent invoice_test2)
			add_boolean_case (agent invoice_test3)
			add_boolean_case (agent invoice_test4)
		end

feature
	invoice_test1: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invoices: INVOICES
		invoice:STRING
		a_order: ARRAY [TUPLE [STRING_8, INTEGER_32]]
	do
		comment("invoice_test1: test adding a new order")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create invoices.make (inventory)

		create a_order.make_empty
		a_order := <<["foo", 5], ["bar", 5]>>
		invoices.add_order (a_order)
		Result := invoices.get_carts.is_equal ("1: bar->5,foo->5%N")

	end

	invoice_test2: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invoices: INVOICES
		invoice:STRING
		a_order: ARRAY [TUPLE [STRING_8, INTEGER_32]]
		a_order2: ARRAY [TUPLE [STRING_8, INTEGER_32]]
	do
		comment("invoice_test2: add 2 orders, invoice 1")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create invoices.make (inventory)

		create a_order.make_empty
		a_order := <<["foo", 5], ["bar", 5]>>
		invoices.add_order (a_order)

		create a_order2.make_empty
		a_order2 := <<["bar", 5]>>
		invoices.add_order (a_order2)

		invoices.invoice (1)
		Result := invoices.orders.at (1).get_state.is_equal ("invoiced")
		check Result end

		Result := invoices.get_states.is_equal ("1->invoiced,2->pending")
	end

	invoice_test3: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invoices: INVOICES
		invoice:STRING
		a_order: ARRAY [TUPLE [STRING_8, INTEGER_32]]
		a_order2: ARRAY [TUPLE [STRING_8, INTEGER_32]]
		index: INTEGER
		invent: STRING
	do
		comment("invoice_test3: add 2 orders, check state status'")
		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create invoices.make (inventory)

		create a_order.make_empty
		a_order := <<["foo", 5], ["bar", 5]>>
		invoices.add_order (a_order)

		create a_order2.make_empty
		a_order2 := <<["bar", 5]>>
		invoices.add_order (a_order2)

		invoices.invoice(1)
		create invoice.make_from_string ("1->invoiced,2->pending")
		Result := invoices.get_states.is_equal (invoice)
	end

	invoice_test4: BOOLEAN
	local
		inventory: MY_BAG[STRING]
		invoices: INVOICES
		invoice:STRING
		a_order: ARRAY [TUPLE [STRING_8, INTEGER_32]]
		index: INTEGER
		invent: STRING
	do
		comment("invoice_test4: test cancelling an order")

		create inventory.make_from_tupled_array (<<["foo", 5],["bar", 10],["bat", 15]>>)
		create invoices.make (inventory)

		create a_order.make_empty
		a_order := <<["foo", 5], ["bar", 5]>>
		invoices.add_order (a_order)

		invoices.cancel_order (1)
		create invoice.make_from_string ("%N")
		Result := invoices.get_carts.is_equal (invoice)



	end
end
