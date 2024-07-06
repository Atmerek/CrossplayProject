local remote_img = require(game.ReplicatedStorage.remote_img);
remote_img.serve(function(player : Player, url : string)
	local is_https = remote_img.builtin.protocols(url, {"https"});
	return is_https
end);
