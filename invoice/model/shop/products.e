note
	description: "Summary description for {PRODUCTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRODUCTS
create
	make

feature {NONE} -- creation

	make
		do
			create products.make_empty
			create stock.make_empty
			create inventory.make(stock)
			create invoices.make (stock)
		end

feature -- attributes
	products: MY_BAG[STRING] -- a list of the products still in the shop
	stock: MY_BAG[STRING] -- reference will be passed to inventory and invoices
	inventory: INVENTORY -- the current list of inventory
	invoices: INVOICES -- the orders

feature -- commands
	add_type(type: STRING)
	do
		products.extend (type, 1)
	end

	add_order(a_order:ARRAY[TUPLE[pid: STRING; no: INTEGER]])
	do
		inventory.add_order (a_order)
		invoices.add_order (a_order)
	end


feature -- inventory commands
	add_product(a_product: STRING; a_quantity: INTEGER)
	do
		inventory.add_product(a_product, a_quantity)
	end


feature -- invoice commands
	invoice(order_id: INTEGER)
	do
		invoices.invoice(order_id)
	end

	cancel_order(order_id: INTEGER)
	do
		invoices.cancel_order(order_id)
	end

feature -- queries
	get_products: STRING
	do
		create Result.make_from_string (" ")
		if products.count > 0 then
			across products.domain as it loop
				Result.append (it.item)
				if not it.is_last then
					Result.append (",")
				end
			end
		end
		Result.append ("%N")
	end

feature -- inventory queries
	get_stock: STRING
	do
		Result := inventory.get_stock
	end

feature -- invoice queries
	get_carts: STRING
	do
		Result := invoices.get_carts
	end

	get_states: STRING
	do
		Result := invoices.get_states
	end

end
