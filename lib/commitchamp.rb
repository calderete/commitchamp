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
    		@search.get_commits
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
		    user = names.each do |x| name = x["author"]["login"]
		   		 	  name.each do |y|  weeks = y["weeks"]
		   		 add = weeks.each do |z| adds = z["a"]
		   					 	  end
		   					 	end
		   					 end
		   			   
		   	data = {
		   		user:      user,
		   		additions: add
		   	}
		   	binding.pry
		 end

		def get_data(owner, repo)
			PullRequests.get("/repos/#{owner}/#{repo}/stats/contributors", :headers => @auth)
		end

		def get_commits
			puts "Who is the owner?"
			owner = gets.chomp.downcase
			puts "Which repo?"
			repo = gets.chomp.downcase
			response = self.get_data(owner, repo)
			total = response.each {|y| y["total"]}
			commits = response.each do |x| week = x["weeks"]
									 ads = week.each do |y| puts y["a"] 
										end
									end 
			
		end

		

	end
end












app = Commitchamp::App.new
app.run
