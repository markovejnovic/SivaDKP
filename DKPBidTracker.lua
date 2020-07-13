dkpbidtracker = {}

dkpbidtracker.tracking_data = {}
dkpbidtracker.bidding = false

dkpbidtracker.start_bidding = function(item_id)
	dkpbidtracker.tracking_data = {}
	dkpbidtracker.tracking_data["item_id"] = item_id
	dkpbidtracker.tracking_data["bids"] = {}
	dkpbidtracker.bidding = true
end

dkpbidtracker.get_max_bid = function()
	local max_bid = {}
	max_bid.item_id = dkpbidtracker.tracking_data["item_id"]
	max_bid.owner = nil
	max_bid.value = -1

	for user, bid in pairs(dkpbidtracker.tracking_data["bids"]) do
		if bid > max_bid.value then
			max_bid.owner = user
			max_bid.value = bid
		end
	end

	return max_bid
end

dkpbidtracker.get_equal_max_bids = function()
	local eq_bids = {}
	eq_bids.item_id = dkpbidtracker.tracking_data["item_id"]
	eq_bids.bids = {}

	local max_bid = dkpbidtracker.get_max_bid()
	eq_bids.bids[max_bid.owner] = max_bid.value

	for user, bid in pairs(dkpbidtracker.tracking_data["bids"]) do
		if bid == max_bid.value then
			eq_bids.bids[user] = bid
		end
	end

	if table.getn(eq_bids.bids) == 1 then
		return nil
	else
		return eq_bids
	end
end



dkpbidtracker.add_bid = function(user, bid)
	if dkpbidtracker.bidding ~= true then
		return -2
	end

	if bid > dkpdb.get_user_dkp(user) then
		return -1
	elseif bid < dkpbidtracker.get_max_bid().value then
		return 1
	else
		dkpbidtracker.tracking_data["bids"][user] = bid
		return 0
	end
end

dkpbidtracker.finish_bidding = function()
	dkpbidtracker.bidding = false
end