# Parcelmagic

###Notes: 

This app requires phoenix 15.0, and not 16+, since views make use of render_one and render_many.  It also requires Postgres 9.4+ since it uses jsonb 

###Setup Application

1. Clone this repo
2. Install dependencies with `mix deps.get`
3. Compile Dependencies with `mix deps.compile`
4. Enter your database credentials in config/dev.exs and config/test.exs

###Setup database

1. Run mix ecto.create to create the db
2. Run mix.ecto.migrate to migrate the tables
3. Run mix mix run priv/repo/seeds.exs to seed with example user

###Start application

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Login with credentials from the seeds file (default is example@example.com, password: password)
