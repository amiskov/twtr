defmodule TwtrWeb.TweetView do
  use TwtrWeb, :view

  def render("index.json", %{tweets: tweets}) do
    %{data: render_many(tweets, __MODULE__, "tweet.json")}
  end

  def render("show.json", params) do
    %{tweet: tweet, replies: replies} = params

    %{
      tweet: render_one(tweet, __MODULE__, "tweet.json"),
      replies: render_many(replies, __MODULE__, "tweet.json")
    }
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      id: tweet.id,
      text: tweet.text,
      likes: tweet.likes
    }
  end
end
