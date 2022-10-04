class Movie < ActiveRecord::Base

    def self.with_ratings(ratings_list)
        # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
        #  movies with those ratings
        # if ratings_list is nil, retrieve ALL movies
        if (ratings_list == [])
            return @all_ratings
        else
            Movie.where('rating IN (?)', ratings_list)
        end
    end

end