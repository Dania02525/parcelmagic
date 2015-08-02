defmodule Parcelmagic.Address do
  use Parcelmagic.Web, :model

  schema "addresses" do
    field :name, :string
    field :company, :string
    field :street1, :string
    field :street2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :country, :string
    field :phone, :string
    field :email, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(street1 city state zip country phone easypost_id)
  @optional_fields ~w(street2 email name company)

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
