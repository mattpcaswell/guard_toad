defmodule GuardToad.Plug do
  use Plug.Builder

  plug Plug.Logger
  plug :add_index_to_path
  plug :authenticate
  plug Plug.Static, 
    at: "/",
    from: :guard_toad
  plug :not_found

  def not_found(conn, _) do
    send_resp(conn, 404, "Not Found!?!?!")
  end

  def add_index_to_path(conn, _) do
    if String.ends_with?(conn.request_path, "/") do
      Map.replace(conn, :path_info, conn.path_info ++ ["index.html"])
    else
      conn
    end
  end

  def authenticate(conn, _) do
    if req_needs_auth(conn) do
      with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
        :ok <- authenticate_ldap(user, pass) do
        conn
      else
        _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
      end
    else
      conn
    end
  end

  def req_needs_auth(conn) do
    true
  end

  def authenticate_ldap(user, pass)  do
    serveraddr = "1.2.3.4"
    port = 43
    ssl = false

    {:ok, connection} = Exldap.connect(serveraddr, port, ssl, user, pass)
  end
end
