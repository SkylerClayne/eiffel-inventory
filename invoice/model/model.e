note
	description: "Summary description for {MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MODEL

inherit
	ANY
	redefine out end

create {MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create shop.make
			i := 0
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	shop: PRODUCTS

feature -- model operations
	default_update(err: STRING)
			-- Perform update to the model state.
		do

		create s.make_from_string ("     " + err)

		s.append ("  id:          ")
		s.append_integer (shop.invoices.last_id_added)
		s.append ("%N")

		s.append ("  products:   ")
		if shop.products.count > 0 then
			s.append (shop.get_products)
		else
			s.append ("%N")
		end

		s.append ("  stock:       ")
		s.append (shop.get_stock)

		s.append ("  orders:      ")
		if shop.invoices.orders.count > 0 then
			s.append (shop.invoices.get_orders)
		else
			s.append ("%N")
		end

		s.append ("  carts:       ")
		s.append (shop.get_carts)

		s.append ("  order_state: ")
		s.append (shop.get_states.out)


		end

	add_type(product_id: STRING)
	do
		if shop.products.has (product_id) then
			default_update ("product type already in database%N")
		elseif product_id.is_empty then
			default_update ("product type must be non-empty string%N")
		else
			shop.add_type (product_id)
			default_update("ok%N")
		end

	end

	add_product(a_product: STRING ; quantity: INTEGER)
	do
		if quantity <= 0 then

			default_update("quantity added must be positive%N")
		elseif not shop.products.bag.has (a_product) then
			default_update("product not in database%N")
		else

			shop.add_product (a_product, quantity)
			default_update("ok%N")
		end
	end

	add_order(a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]])
	do

		if
			across a_order as it all shop.products.bag.has (it.item.pid) end
			and
			across a_order as it some shop.inventory.stock.occurrences (it.item.pid) < it.item.no end
		then
			default_update("not enough in stock%N")
		elseif
			a_order.is_empty
		then
			default_update("cart must be non-empty%N")
		elseif
			across a_order as it some not shop.products.has (it.item.pid) end
		then
			default_update("some products in order not valid%N")
		elseif
			across a_order as it some occurred(it.item.pid, a_order) end
		then
			default_update("duplicate products in order array%N")
		elseif
			across a_order as it some it.item.no < 0 end
		then
			default_update("quantity added must be positive%N")
		else

			shop.add_order (a_order)
			if i = 0 then
				i := 1
			else
				i := i + 1
			end
			default_update("ok%N")

		end
	end

	invoice(order_id: INTEGER)
	do
		if
			across shop.invoices.orders as it all it.item.order_id /= order_id end

		then
			default_update("order id is not valid%N")
		elseif
			across shop.invoices.orders as it some it.item.order_id = order_id and it.item.state.is_equal ("invoiced") end
		then
			default_update("order already invoiced%N")
		else

			shop.invoice (order_id)
			default_update("ok%N")
		end
	end

	cancel_order(order_id: INTEGER)
	do
		if
			across shop.invoices.orders as it all it.item.order_id /= order_id end
		then
			default_update("order id is not valid%N")
		else
			shop.cancel_order (order_id)
			default_update("ok%N")
			i := i - 1
		end
	end

feature -- error handling feature

	occurred(a_pid: STRING; a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]]): BOOLEAN
	local
		look: INTEGER
	do
		look := 0
		across a_order as it loop
			if it.item.pid.is_equal(a_pid) then
				look := look + 1
			end
		end

		if look > 1 then
			Result := true
		else
			Result := false
		end

	end

feature -- queries
	out : STRING
		do
			Result := s
		end

end

