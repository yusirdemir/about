defmodule AboutWeb.TurengView do
  use AboutWeb, :view
  alias AboutWeb.TurengView

  def render("index.json", %{tureng: tureng}) do
    %{data: render_many(tureng, TurengView, "tureng.json")}
  end

  def render("tureng.json", %{tureng: tureng}) do
    %{
      index: tureng.index,
      category: tureng.category,
      turkish: tureng.turkish,
      english: tureng.english,
      type: tureng.type
    }
  end
end
