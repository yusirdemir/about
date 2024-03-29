#! /usr/bin/env elixir

Mix.install([:crawly, :floki, :table_rex, :httpoison])

cli_args = System.argv()
supported_cli_args = [l: :string, q: :string, n: :integer, s: :string, a: :integer]

supported_audio_language = [
  us: "turengVoiceENTRENus",
  uk: "turengVoiceENTRENuk",
  au: "turengVoiceENTRENau"
]

args =
  cli_args
  |> OptionParser.parse(strict: supported_cli_args)
  |> case do
    {parsed_cli_args, _, _} ->
      Map.new(parsed_cli_args)

    _ ->
      raise "Invalid arguments were provided"
  end

l = Map.get(args, :l, "tr")
s = Map.get(args, :s, nil)
a = Map.get(args, :a, nil)
n = Map.get(args, :n, nil)
%{q: q} = args

n = if n in 1..100, do: n, else: 9
a = if a in 1..10, do: a, else: 3

url =
  case l do
    "en" ->
      "https://tureng.com/en/turkish-english/#{q}"

    "tr" ->
      "https://tureng.com/tr/turkce-ingilizce/#{q}"

    _ ->
      raise "Unknown language were provided"
  end

response = Crawly.fetch(url)

{:ok, document} = Floki.parse_document(response.body)

rows =
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
      index = if String.length(index) > 32, do: String.slice(index, 0..32) <> "...", else: index

      category =
        if String.length(category) > 32,
          do: String.slice(category, 0..32) <> "...",
          else: category

      turkish =
        if String.length(turkish) > 32, do: String.slice(turkish, 0..32) <> "...", else: turkish

      english =
        if String.length(english) > 32, do: String.slice(english, 0..32) <> "...", else: english

      type = if String.length(type) > 32, do: String.slice(type, 0..32) <> "...", else: type

      [
        index,
        category,
        turkish,
        english,
        type
      ]

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
      index = if String.length(index) > 32, do: String.slice(index, 0..32) <> "...", else: index

      category =
        if String.length(category) > 32,
          do: String.slice(category, 0..32) <> "...",
          else: category

      turkish =
        if String.length(turkish) > 32, do: String.slice(turkish, 0..32) <> "...", else: turkish

      english =
        if String.length(english) > 32, do: String.slice(english, 0..32) <> "...", else: english

      type = if String.length(type) > 32, do: String.slice(type, 0..32) <> "...", else: type

      [
        index,
        category,
        turkish,
        english,
        type
      ]

    _ ->
      nil
  end)
  |> Enum.filter(&(&1 != nil))
  |> Enum.slice(0..n)

unless Enum.count(rows) > 0 do
  case l do
    "en" ->
      "I couldn't find any results"
      |> IO.puts()

    "tr" ->
      "Herhangi bir sonuç bulunamadı"
      |> IO.puts()

    _ ->
      raise "Unknown language were provided"
  end
else
  header =
    case l do
      "en" ->
        ["Index", "Category", "Turkish", "English", "Type"]

      "tr" ->
        ["Sıra", "Kategori", "Türkçe", "İngilizce", "Tip"]

      _ ->
        raise "Unknown language were provided"
    end

  TableRex.quick_render!(rows, header)
  |> IO.puts()
end

case s do
  nil ->
    nil

  _ ->
    s = supported_audio_language |> Keyword.get(String.to_existing_atom(s))

    path =
      document
      |> Floki.find("audio")
      |> Enum.map(fn
        {"audio", [{_, ^s}, _],
         [
           {_,
            [
              {"src", src},
              _
            ], _}
         ]} ->
          src

        _ ->
          nil
      end)
      |> Enum.filter(&(&1 != nil))
      |> Enum.at(0)

    case path do
      nil ->
        nil

      _ ->
        path = Path.split(path)

        path =
          if Enum.at(path, 0) == "/" do
            [_ | p] = path
            p = Path.join(p)
            Path.join("https://", p)
          else
            path = Path.join(path)
            Path.join("https://", path)
          end

        %_{body: body} = HTTPoison.get!(path)

        File.write!("/tmp/sound.mp3", body)

        Enum.each(
          1..a,
          fn x ->
            System.cmd("ffplay", [
              "/tmp/sound.mp3",
              "-nodisp",
              "-nostats",
              "-hide_banner",
              "-autoexit",
              "-loglevel",
              "error"
            ])

            unless x == a, do: :timer.sleep(1000)
          end
        )

        File.rm!("/tmp/sound.mp3")
    end
end
