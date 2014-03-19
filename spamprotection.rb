#!/usr/bin/ruby

require 'digest'

def print_usage_and_exit
	print "Usage:\n"
	print "#{$0} find <challenge>\n"
	print "#{$0} check <challenge> <solution>\n"
end

THRESHOLD = 200000000000000000000000000000000000000000000000000000000000000000000000

$digest = Digest::SHA256.new

def check(challenge, nonce)
	$digest.update "#{challenge}#{nonce}"
	hash = $digest.hexdigest.to_i(16)
	$digest.reset

	return hash < THRESHOLD
end

mode = ARGV[0]
if mode == "find"
	challenge = ARGV[1]
	
	count = 1
	while true
		nonce = count.to_s(36)
	
		if count % 10000 == 0
			print "Round #{count}\n"
		end
	
		if check(challenge, nonce)
			print "Found solution: '#{nonce}' after #{count} iterations\n"
			exit 0
		end
	
		count += 1
	end
elsif mode == "check"
	challenge = ARGV[1]
	solution = ARGV[2]
	
	result = check(challenge, solution)
	print "#{result}\n"
else
	print_usage_and_exit
end

