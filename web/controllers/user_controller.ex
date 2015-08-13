defmodule Parcelmagic.UserController do
  use Parcelmagic.Web, :controller

  alias Parcelmagic.User
  alias Comeonin.Bcrypt

  plug :scrub_params, "user" when action in [:create, :update]

  def login(conn, params) do
    case User.verifylogin(params) do
      {:ok, id}->
        {:ok, token} = Joken.encode(%{userid: id})
        json conn |> put_status(200), %{"token" => token}
      {:error, reason} ->
        json conn |> put_status(400), %{"message" => reason}
    end
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    params = user_params |> Map.put("password", Bcrypt.hashpwsalt(user_params["password"]))
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render conn, "show.json", user: user
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if Map.has_key?(user_params, "password") do
      params = user_params |> Map.put("password", Bcrypt.hashpwsalt(user_params["password"]))
    else
      params = user_params
    end
    user = Repo.get!(User, id)
    changeset = User.changeset(user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
