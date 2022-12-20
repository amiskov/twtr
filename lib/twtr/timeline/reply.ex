defmodule Twtr.Timeline.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false  
  schema "replies" do
    field :topic_id, :integer, primary_key: true
    field :reply_id, :integer, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:topic_id, :reply_id])
    |> validate_required([:topic_id, :reply_id])
  end
end
