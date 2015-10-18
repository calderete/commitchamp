require "httparty"
require "pry"
require "awesome_print"

require "commitchamp/version"
# Probably you also want to add a class for talking to github.

module Commitchamp
  class App
    def initialize
    	@search = PullRequests.new
    	ap "Welcome to CommitChamp"
    	ap "To begin investigating repo stats type 'begin'"
    	ap "Type any other letter to quit"
    	choice = gets.chomp.downcase
    	if choice == "begin"
    		@search.get_repo_stats
    	else
    		ap "Good bye"
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
			ap  "What is your authorization token?"
			auth_token = gets.chomp
			@auth = {
				"Authorization" => "token #{auth_token}",
				"User-Agent"    => "HTTParty"
			}
		end

		def get_authors
			ap "Which organization do you want to search?"
			owner = gets.chomp.downcase
			ap "Which repository do you want to look into?"
			repo = gets.chomp.downcase
			puts "CONTRIBUTORS"
		    names = self.get_data(owner, repo)
		    contributors = names.each do |x| puts x["author"]["login"]
		    						  end

			sort_options    
		 end

		def get_data(owner, repo)
			PullRequests.get("/repos/#{owner}/#{repo}/stats/contributors", :headers => @auth)
		end

		def get_repo_stats
			puts "Who is the owner?"
			owner = gets.chomp.downcase
			puts "Which repo?"
			repo = gets.chomp.downcase
			get_stats_hash(owner, repo)
		end

		#This method was once part of the get_repo_stats, I broke it apart so I dont have to keep rewriting it
		def get_stats_hash(owner, repo)
			data = self.get_data(owner, repo)
			@stats_data = []
			data.each do |x|
				author = x["author"]["login"]
				a_sum  = x["weeks"].inject(0) { |sum,hash| sum + hash["a"]}
				d_sum  = x["weeks"].inject(0) { |sum,hash| sum + hash["d"]}
				c_sum  = x["weeks"].inject(0) { |sum,hash| sum + hash["c"]}

				@stats_data.push({author:    author, 
								 additions: a_sum, 
								 deletions: d_sum, 
								 commits:   c_sum})
			end
			ap @stats_data
			sort_options
			end

		def sort_options
			additions = @stats_data.sort_by {|k| k[:additions]}
			deletions = @stats_data.sort_by {|k| k[:deletions]}
			commits   = @stats_data.sort_by {|k| k[:commits]}
			ap "To sort by lines added type 'a'"
			ap "To sort by lines deleted type 'd'"
			ap "To sort by commits made type 'c'"
			ap "Type 'sort' to sort again CNTRL D to quit or 'back for another repo search"
			choice = gets.chomp.downcase
			if choice == "a"
				ap additions
			elsif choice == "d"
				ap deletions
			elsif choice == "c"
				ap commits
			elsif choice == "back"
				Commitchamp::App.new
			elsif choice == "sort"
				sort_options 
			else
				puts "Goodbye, come visit CommitChamp again soon!"
			end
			sort_options
		end
		

	end
end












app = Commitchamp::App.new
app.run
