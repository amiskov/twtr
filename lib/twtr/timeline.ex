defmodule Twtr.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias Twtr.Repo

  alias Twtr.Timeline.Tweet
  alias Twtr.Timeline.Like
  alias Twtr.Accounts.User

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets do
    # select tweets.id, tweets.text, tweets.user_id, tweets.inserted_at, tweets.updated_at, count(likes.tweet_id) as likes_count from tweets
    # join likes on tweets.id = likes.tweet_id
    # group by tweets.id;
    # query = from(t in Tweet,
    #   join: l in Like, on: t.id == l.tweet_id,
    #   group_by: :tweet_id,
    #   select: *)
    q = Tweet \
    |> join(:inner, [t], l in Like, on: t.id == l.tweet_id) \
    |> group_by([t], t.id) \
    |> select([t], %{t | likes: count(t.id)})
    #   # select: %{id: c.id, row_number: over(row_number(), :posts_partition)},

    # # Post |> group_by([p], p.category) |> select([p], count(p.id))
    Repo.all(q)
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
        Repo.delete(like)

      nil ->
        %Like{}
        |> Like.changeset(%{tweet_id: tweet_id, user_id: user_id})
        |> Repo.insert()
    end
  end
end
