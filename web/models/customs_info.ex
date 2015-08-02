defmodule Parcelmagic.CustomsInfo do
  use Parcelmagic.Web, :model

  schema "customs_infos" do
    field :contents_type, :string
    field :contents_explanation, :string
    field :customs_certify, :boolean, default: false
    field :non_delivery_option, :string
    field :restriction_type, :string
    field :restriction_comments, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(contents_type contents_explanation customs_certify non_delivery_option restriction_type restriction_comments easypost_id)
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
