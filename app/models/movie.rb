class Movie < ActiveRecord::Base
    def self.all_ratings
      ['G', 'PG', 'PG-13', 'R']
    end
    
    def self.with_ratings(ratings, sort_by)
      if ratings.nil?
        all.order sort_by
      else
        where(rating: ratings.map(&:upcase)).order sort_by
      end
    end

    def self.find_in_tmdb(entry, key="7d00f31609a1879e2fda0da6b3a62b90")
      if entry.is_a?(Hash)
        uri = "https://api.themoviedb.org/3/search/movie?api_key=" + key

        entry.each { |k, v|
          this_param = "&"
          edited_v = v.sub(" ", "%20")

          if k == :title or k == "title"
            this_param = this_param + "query=" + edited_v
            uri = uri + this_param
          elsif k == :release_year or k == "release_year" or k == :language or k == "language"
            this_param = this_param + k.to_s() + "=" + edited_v
            uri = uri + this_param
          end
        }

        response = Faraday.get(uri).body
        all_movies = JSON.parse(response)["results"]

        return_movies = []
        # cycle thru all of the return movies and append the hash in to the return_movies
        # raise Exception.new all_movies
        all_movies.each { |movie|
          this_movie = {"title" => movie["title"], "rating" => "R", "release_date" => movie["release_date"].to_date, "description" => movie["overview"]}

          # just in case the movie doesn't have a release date
          if movie["release_date"] != ""
            already_in_db = Movie.where(title: movie["title"], rating: "R", release_date: movie["release_date"].to_date-1.day..movie["release_date"].to_date+1.day).take
          else
            already_in_db = Movie.where(title: movie["title"], rating: "R", description: movie["overview"])
          end

          if already_in_db == nil
            return_movies.append(this_movie)
          end
        }
        return return_movies

      elsif entry.is_a?(String)
        response = [Faraday.get(entry)]
        return response
      end

    end
  
end
  