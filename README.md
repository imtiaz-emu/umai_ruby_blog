# README

### Pre Requisite
  1. Ruby >= 2.7.2
  2. ['Faker'](https://github.com/faker-ruby/faker) Gem
  3. Database PostgreSQL >= 10

### To Execute
1. clone the repo
2. cd REPO_DIR
3. `ruby app.rb seed` or `ruby app.rb`  


### API References

Added OpenAPI generated json api with paths, models and responses.
Refer to file `UMAI_blog.json`

### Not Covered

1. Test Cases: I could have done with RSPec. Not enough time.
2. Worker: 9AM worker to download all the feedbacks. Could have done with Whenever/Sidekiq. Didn't get the chance.