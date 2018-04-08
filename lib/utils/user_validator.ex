defmodule Channels.Utils.User.Validator do
  @moduledoc """
  Functions to Validate user relationships
  """

  @doc """
  Test that the User exists on DB
  """
  @spec valid?(atom, String.t) :: list
  def valid?(field, user_id) do
    case Channels.Model.Repos.User.exists?(user_id) do
      True -> []
      _ -> [{field , "User <#{user_id}> doesn't exist"}]
    end
  end

end
