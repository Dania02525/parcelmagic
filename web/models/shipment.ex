defmodule Parcelmagic.Shipment do
  use Parcelmagic.Web, :model

  schema "shipments" do
    field :to_address, :map
    field :from_address, :map
    field :return_address, :map
    field :parcel, :map
    field :customs_info, :map
    field :selected_rate, :map
    field :tracking_code, :string
    field :refund_status, :string
    field :insurance, :float
    field :batch_status, :string
    field :batch_message, :string
    field :options, :map
    field :reference, :string
    field :carrier, :string
    field :service, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(to_address from_address return_address parcel customs_info selected_rate tracking_code refund_status insurance batch_status batch_message options reference carrier service easypost_id)
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
