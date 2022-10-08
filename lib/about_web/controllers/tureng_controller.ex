defmodule AboutWeb.TurengController do
  use AboutWeb, :controller

  action_fallback AboutWeb.FallbackController

  def index(conn, params) do
    l = Map.get(params, "l", "en")
    q = Map.get(params, "q", nil)
    n = Map.get(params, "n", nil)

    n =
      case n do
        nil ->
          4

        n when is_binary(n) ->
          String.to_integer(n)

        n when is_integer(n) ->
          n

        _ ->
          raise {:error, :not_found}
      end

    if is_nil(q), do: raise({:error, :not_found})

    url =
      case l do
        "en" ->
          "https://tureng.com/en/turkish-english/#{q}"

        "tr" ->
          "https://tureng.com/tr/turkce-ingilizce/#{q}"

        _ ->
          raise({:error, :not_found})
      end

    response = Crawly.fetch(url)

    {:ok, document} = Floki.parse_document(response.body)

    items =
      document
      |> Floki.find(".searchResultsTable tr")
      |> Enum.map(fn
        {_, _,
         [
           {"td", _, [index]},
           {"td", _, [category]},
           {"td", _, [{"a", _, [turkish]}]},
           {"td", _,
            [
              {"a", _, [english]},
              {"i", _, [type]}
            ]},
           {"td", _, _}
         ]} ->
          %{
            index: index,
            category: category,
            turkish: turkish,
            english: english,
            type: type
          }

        {_, _,
         [
           {"td", _, [index]},
           {"td", _, [category]},
           {"td", _,
            [
              {"a", _, [english]},
              {"i", _, [type]}
            ]},
           {"td", _, [{"a", _, [turkish]}]},
           {"td", _, _}
         ]} ->
          %{
            index: index,
            category: category,
            turkish: turkish,
            english: english,
            type: type
          }

        _ ->
          nil
      end)
      |> Enum.filter(&(&1 != nil))
      |> Enum.slice(0..n)

    render(conn, "index.json", tureng: items)
  end
end
