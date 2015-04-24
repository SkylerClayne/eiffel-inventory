note
	description: "Summary description for {INVOICES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVOICES
create
	make

feature{NONE} -- creation features
	make(a_inventory: MY_BAG[STRING])
	do

		inventory := a_inventory
		create orders.make (0)
		order_index := 1
		create order_ids.make(0)
		last_id_added := 0
	end

feature -- attributes
	orders: ARRAYED_LIST[ORDER] -- a list of all the orders (invoices)
	inventory: MY_BAG[STRING] -- the list of inventory
	order_index: INTEGER
	last_id_added: INTEGER
	order_ids: ARRAYED_LIST[INTEGER]

feature -- commands

	add_order(a_order:ARRAY[TUPLE[pid: STRING; no: INTEGER]])
	local
		bag: MY_BAG[STRING]
		order: ORDER
		other_order: ORDER
		not_added: BOOLEAN
		index: INTEGER
		other_index: INTEGER
		old_order_id: INTEGER
	do
		not_added := true

		if not order_ids.is_empty and not_added then
			create bag.make_from_tupled_array (a_order)
			old_order_id := order_ids.at(1)
			order_ids.prune (order_ids.at(1))

			create order.make (old_order_id, bag)
			orders.force (order)--, order_index)
			last_id_added := old_order_id
			not_added := false
		elseif not_added then


			create bag.make_from_tupled_array (a_order)
			create order.make (order_index, bag)
			last_id_added := order_index

			orders.extend (order)--, order_index)
			not_added := false
		end

			order_index := order_index + 1

	ensure
		orders.count = old orders.count + 1
	end

	invoice(order_id: INTEGER)
	do
		across orders as it loop
			if it.item.order_id = order_id then
				it.item.invoice
			end
		end
	ensure
		across orders as it some it.item.order_id = order_id and then it.item.state.is_equal ("invoiced") end
	end

	cancel_order(order_id: INTEGER)
	local
		remove_id: INTEGER
	do
		if order_id > 0 then

			if
				across orders as it some it.item.order_id = order_id end
			then
				across
					orders as it
				loop
					if it.item.order_id = order_id then
						remove_id := it.cursor_index
					end
				end

				inventory.add_all (orders.at (remove_id).order)
				orders.at (remove_id).cancel
				order_ids.extend (orders.at (remove_id).order_id)
				orders.prune_all (orders.at (remove_id)) --added with array_list imp
				order_index := order_index - 1

			end
		end
	ensure
		order_index = old order_index - 1
	end

feature -- queries
	get_carts: STRING
	local
		look: INTEGER
	do
		create Result.make_empty
		look := 0
		across orders as it loop
			if it.item.get_state.is_equal ("pending") or it.item.get_state.is_equal ("invoiced") then
				if look > 0 then
					Result.append("               ")
				end
				Result.append_integer (it.item.order_id)
				Result.append (": ")
				Result.append(it.item.get_order)
				if
					not it.is_last
					and
					not it.item.get_order.is_empty
				then
					Result.append ("%N")
				end
				look := look + 1
			end
		end
		Result.append ("%N")
	end

	get_orders: STRING
	do
		create Result.make_empty
		across orders as it loop
			if it.item.get_state.is_equal ("pending") or it.item.get_state.is_equal ("invoiced")  then
				Result.append_integer (it.item.order_id)
				if
					not it.is_last

					and
					it.item.get_order.count > 5
				then
					Result.append (",")
				end
			end
		end
		Result.append ("%N")

	end

	get_states: STRING
	do
		create Result.make_empty
		across orders as it loop
		if it.item.get_state.is_equal ("pending") or it.item.get_state.is_equal ("invoiced")  then
			Result.append_integer (it.item.order_id)
			Result.append ("->")
			Result.append(it.item.get_state)
			if
				not it.is_last
			then

			Result.append (",")
			end
		end
		end
	end

end
