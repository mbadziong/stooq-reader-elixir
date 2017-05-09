defmodule Webapp.PageControllerTest do
  use Webapp.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Stooq Reader"
  end
end
