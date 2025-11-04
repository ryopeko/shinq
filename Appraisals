# Every Minor Version for the Current and Last Major Releases
# Latest Minor Version for the Older Releases.
# https://guides.rubyonrails.org/maintenance_policy.html
#
# When you update this, do not forget to update CI settings for matrix testing.

# # Since bundler v1 and Appraisals are not well interacted,
# # we do not test the rails-4 here.
# appraise "rails-4" do
#   gem "rails", "~> 4.0"
# end

appraise "rails-7.0" do
  gem "activesupport", "~> 7.0.0"
  gem "activejob", "~> 7.0.0"
  gem 'concurrent-ruby', '1.3.4' # https://stackoverflow.com/a/79361034
end

appraise "rails-7.1" do
  gem "activesupport", "~> 7.1.0"
  gem "activejob", "~> 7.1.0"
end

appraise "rails-7.2" do
  gem "activesupport", "~> 7.2.0"
  gem "activejob", "~> 7.2.0"
end

appraise "rails-8.0" do
  gem "activesupport", "~> 8.0.0"
  gem "activejob", "~> 8.0.0"
end

appraise "rails-8.1" do
  gem "activesupport", "~> 8.1.0"
  gem "activejob", "~> 8.1.0"
end
