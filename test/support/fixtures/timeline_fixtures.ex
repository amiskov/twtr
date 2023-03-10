defmodule Twtr.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twtr.Timeline` context.
  """

  @doc """
  Generate a tweet.
  """
  def tweet_fixture(attrs \\ %{}) do
    {:ok, tweet} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Twtr.Timeline.create_tweet()

    tweet
  end
end
