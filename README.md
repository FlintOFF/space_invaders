![funny radar gif](public/radar.gif)

# Automatic target recognition of Space Invaders
[![Maintainability](https://api.codeclimate.com/v1/badges/e5a61b96be43522b3382/maintainability)](https://codeclimate.com/github/FlintOFF/space_invaders/maintainability)

This is my realization for test task "SPACE INVADERS".
You can read full description for this task in the file [TASK.md](TASK.md).

#### Requirements:

* Ruby/Rails versions
    * ruby ~> '2.5.1'
    * rails ~> '5.2.1'

* System dependencies
    * postgresql 9.6

## Install
* `git clone git@github.com:FlintOFF/space_invaders.git`
* `cd space_invaders`
* `rm config/credentials.yml.enc`
* `EDITOR=nano rails credentials:edit`
* `cp config/database.yml.sample config/database.yml`
* `nano config/database.yml`
* `./bin/setup`
* `rake tasks:handle`
* `rails s`

## Deploy to Heroku
```
git push heroku master
heroku config:set RAILS_MASTER_KEY=<your-master-key-here>
heroku run rake db:setup
```

## Test:
* For run all tests `rails test`
* For test manually over CLI on heroku:
    * generate token `curl -d '{"email": "smstur@gmail.com", "password": "super_password"}' -H "Content-Type: application/json" -X POST https://space-invaders-atr.herokuapp.com/api/tokens`
    * get task result `curl -H "Authorization: Bearer <token>" -H "Content-Type: application/json" https://space-invaders-atr.herokuapp.com/api/tasks/1` as result you will see positions of the targets from test task.
* Through Swagger UI by [link](https://space-invaders-atr.herokuapp.com)

## About
**This project contains next models:**
* Radar - contains information about radar system, like: frame_height, frame_width, frame_symbols;
* Target - for each radar system, we need to create they own targets. You can specify next parameters: title, description, frame, kind (enemy or friend);
* Task - for recognition the targets on radar frame you need create the task. Task contain next information: radar_id, frame, results, status;
* User - contain information about the user and his role;

For authorization I use JWT. 
First, you need to generate JWT over endpoint '/api/tokens'. 
After, you need send your token over the header for each request. For example "Authorization: Bearer <token>".

You can find the recognition logic by the path `app/commands/detect_target_command.rb`. 
This piece of code is absolutely separated from this project and can be moved to GEM and reused in another project.  

Please take a look on the integration test `test/integration/api/task_flow_test.rb`. It works with data from the test task and contains the results for it.    

## To do:
* Visualize results on image;
* Filtering the noise over 'median filter';
* Return unknown targets;
* Realize async work (background jobs + callback url);
* Think about upload radar frame through a file or single string;
* Move recognition logic to GEM;

## Issues:
* Swagger do not support JWT
