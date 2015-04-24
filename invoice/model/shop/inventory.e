note
	description: "Summary description for {INVENTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVENTORY

create
	make

feature {NONE} -- creation

	make(a_bag: MY_BAG[STRING])
	do
		create stock.make_empty
		stock := a_bag
	end

feature -- attributes
	stock: MY_BAG[STRING] -- reference will be passed to inventory and invoices

feature -- commands
	add_product(a_product: STRING; a_quantity: INTEGER)
	do
		stock.extend (a_product, a_quantity)
	ensure
		added_to_bag: stock.has (a_product)
	end

	add_order(a_order:ARRAY[TUPLE[pid: STRING; no: INTEGER]])
	local
		order: MY_BAG[STRING]
	do
		create order.make_from_tupled_array (a_order)
		stock.remove_all (order)
	end

feature -- queries
	get_stock: STRING
	local
		index: INTEGER
	do
		create Result.make_empty
		across stock as it loop

			index := index + 1
			Result.append(it.item)
			Result.append("->")
			Result.append_integer (stock.occurrences (it.item))
			if index < stock.count then
				Result.append (",")
			end
		end
		Result.append ("%N")
	end

end
