# Twtr

## API TODO
- [ ] Users
  - [x] `POST /api/sign_in`
  - [ ] Log Out
  - [ ] Register
- [ ] Tweets CRUD
  - [x] `GET  /api/tweets`
  - [x] `GET  /api/tweets/:id`
  - [x] `POST /api/tweets` + auth
  - [ ] `PUT  /api/tweets` + auth
- [ ] Replies
  - [x] Add replies to tweet endpoint
  - [ ] Create reply
- [ ] Likes
  - [ ] Liked tweets for auth user
- [ ] Followers

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
