defmodule Twtr.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies, primary_key: false) do
      add :topic_id, references(:tweets, on_delete: :delete_all), null: false, primary_key: true
      add :reply_id, references(:tweets, on_delete: :delete_all), null: false, primary_key: true

      timestamps()
    end
  end
end
