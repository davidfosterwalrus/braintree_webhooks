# README

# Braintree Webhook Handler Integration

Hello! Welcome to the Braintree Webhook Handler. This is a web application that can be downloaded, configured with your Braintree API Keys, and launched to the endpoint in your choice. In this example, we'll recommend Heroku, but you can use whatever you'd like.

This tool allows you to receive Braintree webhooks at your endpoint, and will parse the payloads, store them in a database, and allow you to retrieve them later with the built-in search engine. The UI sorts your webhook results into a table in  sdescending order by timestamp. The table displays `webhook_kind`, `timestamp`, and allows you to expand the full result object - which can then be copied to the clipboard with the ease of a button click.

The homepage loads webhooks received in the last 24 hours by default. If you attempt a search that yields `no results`, the default of results from the past 24 hours will be displayed instead alongside a message that informs you that no results were returned.

An example of this application can be viewed here: https://webhooks-km.herokuapp.com/

**Dependencies**
* Ruby v2.7.1
* Rails v6.0.3.3
* Braintree Ruby v2.103.0
* Bootstrap v3.4.1
* JQuery v3.5.1
* Postgresql
* Git
* Heroku

**Note**
Many of the dependencies are built into the Gemfile bundle itself. Dependencies that will need to be installed prior to project installation:

* Ruby // https://rvm.io/rvm/install
* Git // https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
* Postgresql // http://postgresql.org/
* Heroku // http://heroku.com/

Since this project runs on a specific version of Ruby, and your machine may be using Ruby locally for internal tasks, it's best to use a Ruby version manager tool to keep these versions separate. Rbenv and RVM both work great. I personally prefer to use RVM to manage my Ruby versions: https://rvm.io/rvm/install.

If already using RVM, you can update to the latest version of Ruby via the command line simply by using the command:

```
rvm install 2.7.1
```
Once CD'd into the project directory, you may also need to tell it what version of Ruby to use before installing the bundle:

```
rvm use -v2.7.1
```

**Note**
This application was built to be used in a testing capacity for the sandbox environment only. Not recommended for production implementations.

### Setup

1. Download this project.

2. Open the project in a text editor, and navigate to the file `config/local_env.yml`. Enter your Braintree API keys here. Once this is done, it's best practice to add this file to your `.gitignore` file.

3. Set up your Postgresql database. Create a new Postgre database on your machine, then assign it as your database in the `database.yml` file:

```
default: &default
  adapter: postgresql
  encoding: unicode
  # username: '' //optional
  # password: '' //optional
  pool: 5
  timeout: 5000
  # host: ''

development:
  <<: *default
  database: '' //enter db name here
test:
  <<: *default
  database: '' //enter db name here
production:
  <<: *default
  database: '' //enter db name here
```

4. Now you'll want to install the entire project. In your terminal, navigate to the root directory of the project and type:
```
bundle install
```

If all of the dependencies are properly installed, this should work. If you receive any errors, follow the trace and fix any conflicts arise.

5. Initialize a new Git repo, make an initial commit, and migrate the database:

```
git init
git add .
git commit -m"initial commit"
rails db:migrate
```

6. Create new Heroku endpoint and push:

```
heroku create
git push heroku master
```

7. After Heroku build is complete, migrate the database to Heroku:

```
heroku run rails db:migrate
```

8. Your Webhook Handler should now be live at your endpoint! Navigate to your endpoint with:

```
heroku open
```

9. Add your webhook endpoint to your Braintree webhook configuration in the Control Panel.

To create a webhook:
  1. Log into the Control Panel
  2. Click on the gear icon in the top right corner
  3. Click API from the drop-down menu
  4. Click on the Webhooks tab
  5. Click the Create New Webhook button
  6. Provide your destination URL and make your notification selections
  7. Click the Create Webhook button

**Important**
The POST path for your webhook endpoint will be `/webhook`. You will have to add this to the end of your URL when entering it into your Braintree Control Panel. So if your endpoint is `webhooks.com`, you'll need to enter your endpoint as `webhooks.com/webhook` in Braintree.

**https://developers.braintreepayments.com/guides/webhooks/create**

### Built With

* [Rails v6.0.3.3 / Ruby 2.7.1](http://rubyonrails.org/) - The web framework used
* [Bootstrap v3.3.7](https://getbootstrap.com/) - HTML and CSS framework for styling
* [Braintree Ruby v2.103.0 and Braintree Web v.3.65.0](https://braintreepayments.com) - Payment functionality
* [Postgresql](http://postgresql.org/) - Database

Thank you and enjoy!
