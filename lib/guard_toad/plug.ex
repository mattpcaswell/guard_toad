defmodule GuardToad.Plug do
  use Plug.Builder

  plug Plug.Logger
  plug :add_index_to_path
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
end
