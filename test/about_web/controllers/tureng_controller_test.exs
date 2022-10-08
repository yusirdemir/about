defmodule AboutWeb.TurengControllerTest do
  use AboutWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all tureng with turkish to english with turkish language", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), l: "tr", q: "merhaba")
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with turkish to english with turkish language 10 result", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), l: "tr", q: "merhaba", n: 10)
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with turkish to english with english language", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), q: "merhaba")
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with turkish to english with english language 10 result", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), q: "merhaba", n: 10)
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with english to turkish with turkish language", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), l: "tr", q: "hello")
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with english to turkish with turkish language 10 result", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), l: "tr", q: "hello", n: 10)
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with english to turkish with english language", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), q: "hello")
    assert json_response(conn, 200)["data"]
  end

  test "lists all tureng with english to turkish with english language 10 result", %{conn: conn} do
    conn = get(conn, Routes.tureng_path(conn, :index), q: "hello", n: 10)
    assert json_response(conn, 200)["data"]
  end
end
