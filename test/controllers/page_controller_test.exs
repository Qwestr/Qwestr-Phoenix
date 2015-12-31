defmodule Qwestr.PageControllerTest do
  use Qwestr.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Qwestr!"
  end
end
