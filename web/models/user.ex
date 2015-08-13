defmodule Parcelmagic.User do
  use Parcelmagic.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps
  end

  def verifylogin(params) do
    case Parcelmagic.Repo.get_by(Parcelmagic.User, email: params["email"]) do
      nil ->
        {:error, "Not found"}
      user ->
        if Bcrypt.checkpw(params["password"], user.password) do
          {:ok, user.id}
        else
          {:error, "Bad password"}
        end
    end
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
