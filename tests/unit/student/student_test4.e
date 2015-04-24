note
	description: "Summary description for {PRODUCTS_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST4

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent products_tests1)
			add_boolean_case (agent products_tests2)
			add_boolean_case (agent products_tests3)
			add_boolean_case (agent products_tests4)
		end

feature
	products_tests1: BOOLEAN
	local
		products: PRODUCTS
		test: STRING
	do
		comment("products_tests1: adding types")
		create products.make
		products.add_type ("foo")

		create test.make_empty
	--	test.append ()
		Result := products.get_products.is_equal (" foo%N")


		check Result end

		products.add_type ("bar")

		create test.make_empty
		test.append (" bar,foo%N")
		Result := products.get_products.is_equal (test)
	end

	products_tests2: BOOLEAN
	local
		products: PRODUCTS
		invoice:STRING
		index: INTEGER
		test: STRING
	do
		comment("products_tests2: add products to stock")


		create products.make
		products.add_type ("foo")
		products.add_product ("foo", 5)
		products.add_type ("bar")
		products.add_product ("bar", 10)
		products.add_type ("bat")
		products.add_product ("bat", 15)

		create invoice.make_from_string ("bar->10,bat->15,foo->5%N")
		Result := products.get_stock.is_equal (invoice)

	end

	products_tests3: BOOLEAN
	local
		products: PRODUCTS
		invoice:STRING
		index: INTEGER
		test: STRING
	do
		comment("products_testss3: add an order")

		create products.make
		products.add_type ("foo")
		products.add_product ("foo", 5)
		products.add_type ("bar")
		products.add_product ("bar", 10)
		products.add_type ("bat")
		products.add_product ("bat", 15)

		products.add_order (<<["foo", 5], ["bar", 5]>>)

		create invoice.make_from_string ("1: bar->5,foo->5%N")
		Result := products.get_carts.is_equal (invoice)
		check Result end

		create invoice.make_from_string ("bar->5,bat->15%N")
		Result := products.get_stock.is_equal (invoice)

	end

	products_tests4: BOOLEAN
	local
		products: PRODUCTS
		invoice:STRING
		index: INTEGER
		test: STRING
	do
		comment("products_tests4: invoicing an order")

		create products.make
		products.add_type ("foo")
		products.add_product ("foo", 5)
		products.add_type ("bar")
		products.add_product ("bar", 10)
		products.add_type ("bat")
		products.add_product ("bat", 15)

		products.add_order (<<["foo", 5], ["bar", 5]>>)
		products.add_order (<<["bar", 5]>>)
		create invoice.make_from_string ("bat->15%N")
		Result := products.get_stock.is_equal (invoice)
		check Result end


		create invoice.make_from_string ("1->pending,2->pending")
		Result := products.get_states.is_equal (invoice)
		check Result end


		products.invoice (1)
		create invoice.make_from_string ("1->invoiced,2->pending")
		Result := products.get_states.is_equal (invoice)
	end

end
