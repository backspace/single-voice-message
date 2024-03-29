defmodule SingleVoiceMessageWeb.MessageTest do
  use SingleVoiceMessage.ModelCase

  alias SingleVoiceMessageWeb.Message

  @valid_attrs %{url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
