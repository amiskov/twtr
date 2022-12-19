defmodule Twtr.Timeline.Like do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false  
  schema "likes" do
    field :tweet_id, :integer, primary_key: true
    belongs_to :user, Twtr.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:tweet_id, :user_id])
    |> validate_required([:tweet_id, :user_id])
  end
end
