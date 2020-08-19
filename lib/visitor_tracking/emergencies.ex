defmodule VisitorTracking.Emergencies do
  @moduledoc """
  The Emergencies context.
  """

  import Ecto.Query, warn: false
  alias VisitorTracking.Repo

  alias VisitorTracking.Emergencies.Emergency

  @doc """
  Returns the list of emergencies.

  ## Examples

      iex> list_emergencies()
      [%Emergency{}, ...]

  """
  def list_emergencies do
    Repo.all(Emergency)
  end

  @doc """
  Gets a single emergency.

  Raises `Ecto.NoResultsError` if the Emergency does not exist.

  ## Examples

      iex> get_emergency!(123)
      %Emergency{}

      iex> get_emergency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_emergency!(id), do: Repo.get!(Emergency, id)

  @doc """
  Creates a emergency.

  ## Examples

      iex> create_emergency(%{field: value})
      {:ok, %Emergency{}}

      iex> create_emergency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_emergency(attrs \\ %{}) do
    %Emergency{}
    |> Emergency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a emergency.

  ## Examples

      iex> update_emergency(emergency, %{field: new_value})
      {:ok, %Emergency{}}

      iex> update_emergency(emergency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_emergency(%Emergency{} = emergency, attrs) do
    emergency
    |> Emergency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a emergency.

  ## Examples

      iex> delete_emergency(emergency)
      {:ok, %Emergency{}}

      iex> delete_emergency(emergency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_emergency(%Emergency{} = emergency) do
    Repo.delete(emergency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking emergency changes.

  ## Examples

      iex> change_emergency(emergency)
      %Ecto.Changeset{data: %Emergency{}}

  """
  def change_emergency(%Emergency{} = emergency, attrs \\ %{}) do
    Emergency.changeset(emergency, attrs)
  end
end
