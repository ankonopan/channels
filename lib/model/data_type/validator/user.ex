defmodule Channels.Model.DataType.Validator.User do
  @moduledoc """
  Functions to Validate user relationships
  """
  use Channels.Model

  @doc """
  Test that the User exists on DB
  """
  @spec valid?(atom, String.t) :: list
  def valid?(field, user_id) do
    case Type.User.exists?(user_id) do
      true -> []
      _ -> [{field , "User <#{user_id}> doesn't exist"}]
    end
  end

end
