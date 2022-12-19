defmodule Twtr.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :text, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
