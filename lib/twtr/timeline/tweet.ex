defmodule Twtr.Timeline.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :text, :string
    field :likes, :integer, virtual: true, redact: true

    belongs_to :user, Twtr.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
  end

  @doc false
  def reply_changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:text, :user_id, :topic_tweet_id])
    |> validate_required([:text, :user_id, :topic_tweet_id])
  end
end
