defmodule Twtr.TimelineTest do
  use Twtr.DataCase

  alias Twtr.Timeline

  describe "tweets" do
    alias Twtr.Timeline.Tweet

    import Twtr.TimelineFixtures

    @invalid_attrs %{text: nil}

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Timeline.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Timeline.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Tweet{} = tweet} = Timeline.create_tweet(valid_attrs)
      assert tweet.text == "some text"
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Tweet{} = tweet} = Timeline.update_tweet(tweet, update_attrs)
      assert tweet.text == "some updated text"
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_tweet(tweet, @invalid_attrs)
      assert tweet == Timeline.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Timeline.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Timeline.change_tweet(tweet)
    end
  end
end
