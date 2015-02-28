# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(title: movie['title'], rating: movie['rating'], release_date: movie['release_date'], director: movie['director'])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',')
  if uncheck
    ratings.each { |rating|
      r = "ratings_" + rating
      step "I uncheck \"#{r}\""
    }
  else
    ratings.each { |rating|
      r = "ratings_" + rating
      step "I check \"#{r}\""    }
  end
end

Then /the table should( not)? list movies with the ratings: (.*)/ do |unchecked, rating_list|
  puts page.html
  selected_ratings = rating_list.split(',').map {|n| n.strip}
  selected_ratings.each do |rating|
    if unchecked
      step "I should not see /^#{rating}$/ within \"table#movies\""
    else 
      step "I should see /^#{rating}$/ within \"table#movies\""
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each { |m|
    assert page.body.index(m.title) > 0
  }
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |arg1, arg2|
  puts page.body.index(arg2) > 0 
end

Then /I should be on the Similar Movies page for (.*)/ do |movie|
  puts page.body.index("Same director movies as #{movie[1..-2]}") > 0
end








