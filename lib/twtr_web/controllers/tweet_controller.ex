defmodule TwtrWeb.TweetController do
  use TwtrWeb, :controller

  alias Twtr.Timeline
  alias Twtr.Timeline.Tweet

  def index(conn, _params) do
    tweets = Timeline.list_tweets()
    render(conn, :index, tweets: tweets)
  end

  # def index_json(conn, _params) do
  #   tweets = Timeline.list_tweets()
  #   render(conn, "index.json", tweets: tweets)
  # end

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
    %{tweet: tweet, replies: replies} = Timeline.get_tweet_with_replies!(id)
    render(conn, :show, tweet: tweet, replies: replies)
  end

  def edit(conn, %{"id" => id}) do
    tweet = Timeline.get_tweet!(id)
    changeset = Timeline.change_tweet(tweet)
    render(conn, "edit.html", tweet: tweet, changeset: changeset)
  end

  def reply(conn, %{"tweet_id" => id} = attrs) do
    topic = Timeline.get_tweet!(id)
    changeset = Timeline.change_tweet(%Tweet{}, attrs)
    render(conn, "reply.html", topic: topic, changeset: changeset)
  end

  def do_reply(conn, %{"tweet" => tweet} = params) do
    %{"text" => reply_text, "topic_tweet_id" => topic_tweet_id} = tweet
    %Plug.Conn{assigns: %{current_user: current_user}} = conn
    params = Map.put(tweet, "user_id", current_user.id)

    # TODO: There should be transaction

    case Timeline.create_tweet(params) do
      {:ok, tweet} ->
        Timeline.create_reply(%{"topic_id" => topic_tweet_id, "reply_id" => tweet.id})

        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.tweet_path(conn, :show, tweet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "reply.html", changeset: changeset)
    end
  end

  def like(conn, %{"tweet_id" => tweet_id}) do
    %Plug.Conn{assigns: %{current_user: current_user}} = conn

    case Timeline.toggle_like(tweet_id, current_user.id) do
      {:deleted, {:ok, _}} ->
        conn
        |> put_flash(:info, "Like has beed removed!")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:inserted, {:ok, _}} ->
        conn
        |> put_flash(:info, "You liked a tweet!")
        |> redirect(to: Routes.tweet_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("index.html", changeset: changeset)
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
