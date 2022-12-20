defmodule Twtr.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias Twtr.Repo

  alias Twtr.Timeline.Tweet
  alias Twtr.Timeline.Like
  alias Twtr.Timeline.Reply

  def print_sql(queryable) do
    IO.inspect(Ecto.Adapters.SQL.to_sql(:all, Repo, queryable))
    queryable
  end

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]
  """
  def list_tweets do
    Tweet
    |> distinct(true)
    |> join(:left, [t], l in Like, on: t.id == l.tweet_id)
    |> join(:left, [t], r in Reply, on: t.id == r.topic_id)
    |> group_by([t, _, r], [t.id, r.reply_id])
    |> select([t, l, r], %{t | likes: count(l.tweet_id), replies: count(r.reply_id)})
    |> Repo.all()
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  def get_tweet_with_replies!(id) do
    tweet = Repo.get!(Tweet, id)

    replies =
      Tweet
      |> join(:inner, [t], r in Reply, on: t.id == r.reply_id)
      |> where([_t, r], r.topic_id == ^tweet.id)
      |> Repo.all()

    %{tweet: tweet, replies: replies}
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
  end

  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{data: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet, attrs \\ %{}) do
    Tweet.changeset(tweet, attrs)
  end

  def toggle_like(tweet_id, user_id) do
    case Repo.get_by(Like, tweet_id: tweet_id, user_id: user_id) do
      %Like{} = like ->
        l = Repo.delete(like)
        {:deleted, l}

      nil ->
        l =
          %Like{}
          |> Like.changeset(%{tweet_id: tweet_id, user_id: user_id})
          |> Repo.insert()

        {:inserted, l}
    end
  end
end
