defmodule VisitorTracking.Form do
  @moduledoc """
  The Form context.
  """

  import Ecto.Query, warn: false
  alias VisitorTracking.Repo

  alias VisitorTracking.Form.ContactForm

  @doc """
  Returns the list of contact_forms.

  ## Examples

      iex> list_contact_forms()
      [%ContactForm{}, ...]

  """
  def list_contact_forms do
    Repo.all(ContactForm)
  end

  @doc """
  Gets a single contact_form.

  Raises `Ecto.NoResultsError` if the Contact form does not exist.

  ## Examples

      iex> get_contact_form!(123)
      %ContactForm{}

      iex> get_contact_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact_form!(id), do: Repo.get!(ContactForm, id)

  @doc """
  Creates a contact_form.

  ## Examples

      iex> create_contact_form(%{field: value})
      {:ok, %ContactForm{}}

      iex> create_contact_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact_form(attrs \\ %{}) do
    %ContactForm{}
    |> ContactForm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact_form.

  ## Examples

      iex> update_contact_form(contact_form, %{field: new_value})
      {:ok, %ContactForm{}}

      iex> update_contact_form(contact_form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact_form(%ContactForm{} = contact_form, attrs) do
    contact_form
    |> ContactForm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact_form.

  ## Examples

      iex> delete_contact_form(contact_form)
      {:ok, %ContactForm{}}

      iex> delete_contact_form(contact_form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact_form(%ContactForm{} = contact_form) do
    Repo.delete(contact_form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact_form changes.

  ## Examples

      iex> change_contact_form(contact_form)
      %Ecto.Changeset{data: %ContactForm{}}

  """
  def change_contact_form(%ContactForm{} = contact_form, attrs \\ %{}) do
    ContactForm.changeset(contact_form, attrs)
  end
end
