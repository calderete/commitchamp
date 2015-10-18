require "httparty"
require "pry"

require "commitchamp/version"
# Probably you also want to add a class for talking to github.

module Commitchamp
  class App
    def initialize
    	@search = PullRequests.new
    	puts "Welcome to CommitChamp!"
    	puts "Please make a choice"
    	puts "'lc' for a list of contributors"
    	puts "'a' for number of additions"
    	choice = gets.chomp.downcase
    	if choice == "lc"
    		@search.get_authors
    	elsif choice == "a"
    		@search.get_repo_stats
    	else
    		puts "Good bye"
    	end
    end

    def run
      # Your code goes here...
    end
  end
end

module Commitchamp
	class PullRequests
		include HTTParty
		base_uri "https://api.github.com"
		def initialize
			puts "What is your authorization token?"
			auth_token = gets.chomp
			@auth = {
				"Authorization" => "token #{auth_token}",
				"User-Agent"    => "HTTParty"
			}
		end

		def get_authors
			puts "Which organization do you want to search?"
			owner = gets.chomp.downcase
			puts "Which repository do you want to look into?"
			repo = gets.chomp.downcase
			puts "CONTRIBUTORS"
		    names = self.get_data(owner, repo)
		    contributors = names.each do |x| puts x["author"]["login"]
		    						  end
		    
		 end

		def get_data(owner, repo)
			PullRequests.get("/repos/#{owner}/#{repo}/stats/contributors", :headers => @auth)
		end

		def get_repo_stats
			puts "Who is the owner?"
			owner = gets.chomp.downcase
			puts "Which repo?"
			repo = gets.chomp.downcase
			data = self.get_data(owner, repo)
					
			stats_data = []
			data.each do |x|
				author = x["author"]["login"]
				a_sum  = x["weeks"].inject(0) { |sum,hash| sum + hash["a"]}

				stats_data.push({author: author, a: a_sum})
			end
			binding.pry
			end

		

	end
end












app = Commitchamp::App.new
app.run
