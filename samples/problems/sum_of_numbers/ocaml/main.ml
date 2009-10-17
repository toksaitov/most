let main = read_line() in
	let sum = Scanf.sscanf main "%d %d" (fun x y -> x + y) in
		print_int sum;;