defmodule TwtrWeb.TweetController do
  use TwtrWeb, :controller

  alias Twtr.Timeline
  alias Twtr.Timeline.Tweet
  alias Twtr.Timeline.Like

  def index(conn, _params) do
    tweets = Timeline.list_tweets() |> IO.inspect
    render(conn, "index.html", tweets: tweets)
  end

  def new(conn, _params) do
    changeset = Timeline.change_tweet(%Tweet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    %Plug.Conn{assigns: %{current_user: current_user}} = conn
    params = Map.put(tweet_params, "user_id", current_user.id)
    case Timeline.create_tweet(params) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.tweet_path(conn, :show, tweet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tweet = Timeline.get_tweet!(id)
    render(conn, "show.html", tweet: tweet)
  end

  def edit(conn, %{"id" => id}) do
    tweet = Timeline.get_tweet!(id)
    changeset = Timeline.change_tweet(tweet)
    render(conn, "edit.html", tweet: tweet, changeset: changeset)
  end

  def like(conn, %{"tweet_id" => tweet_id}) do
    %Plug.Conn{assigns: %{current_user: current_user}} = conn

    case Timeline.toggle_like(tweet_id, current_user.id) do
      {:ok, like} ->
        conn
        |> put_flash(:info, "You liked a tweet!")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "tweet" => tweet_params}) do
    tweet = Timeline.get_tweet!(id)

    case Timeline.update_tweet(tweet, tweet_params) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Tweet updated successfully.")
        |> redirect(to: Routes.tweet_path(conn, :show, tweet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tweet: tweet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Timeline.get_tweet!(id)
    {:ok, _tweet} = Timeline.delete_tweet(tweet)

    conn
    |> put_flash(:info, "Tweet deleted successfully.")
    |> redirect(to: Routes.tweet_path(conn, :index))
  end
end
