defmodule Channels.Model.DataType.Utils.Record do

  @doc """
  Receive a cell and fills the timestamp information to prepare it for
  inserting on DB

  """
  def update_timestamps(data_type) do
    case data_type do
      %{inserted_at: nil} ->
        %{data_type | inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}
      %{inserted_at: value} ->
        %{data_type | updated_at: DateTime.utc_now()}
      _ ->
        Map.merge(data_type, %{inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
    end
  end
end
