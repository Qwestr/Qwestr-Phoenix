defmodule Qwestr.Enums.Repeat do
	import EctoEnum

	# see http://hexdocs.pm/ecto_enum/ for documentation
	defenum Values, 
		never:		0, 
		daily: 		1, 
		weekly:		2, 
		monthly:	3, 
		yearly: 	4

	def select_map do
		[
			never:		"never", 
			daily: 		"daily", 
			weekly: 	"weekly", 
			monthly:	"monthly", 
			yearly: 	"yearly"
		]
	end
end