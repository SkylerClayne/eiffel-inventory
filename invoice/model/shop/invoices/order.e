note
	description: "Summary description for {ORDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER
create
	make

feature{NONE} -- creation

	make(a_order_id: INTEGER; a_order:MY_BAG[STRING])
	do
		create order.make_empty
		order := a_order
		create state.make_from_string ("pending")
 		set_order_id(a_order_id)
	end

feature -- attributes
	order: MY_BAG[STRING]
	state: STRING
	order_id: INTEGER

feature
	set_order_id(a_order_id: INTEGER)
	require
		positive_id: a_order_id > 0
	do
		if a_order_id > 0 then
			order_id := a_order_id
		end
	ensure
		order_id = a_order_id
	end

feature -- commands
	pending
	require
		not	state.is_equal ("pending")
	do
		create state.make_from_string ( "pending")
	ensure
		state.is_equal ("pending")
	end

	invoice
	require
		not	state.is_equal ("invoiced")
	do
		create state.make_from_string ( "invoiced")
	ensure
		state.is_equal ("invoiced")
	end


	cancel
	require
		not	state.is_equal ("cancelled")
	do
		create state.make_from_string ( "cancelled")
	ensure
		state.is_equal ("cancelled")
	end

feature -- queries
	get_order: STRING
	local
		index: INTEGER
	do
		create Result.make_empty
		index := 0
		across order as it loop
			index := index + 1
			Result.append(it.item)
			Result.append("->")
			Result.append_integer (order.occurrences (it.item))
			if index < it.a_bag.count then
				Result.append(",")
			end
		end
	end

	get_state: STRING
	do
		Result := Current.state
	ensure
		Result = Current.state
	end

end
