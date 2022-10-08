defmodule About.TranslateTest do
  use About.DataCase

  alias About.Translate

  describe "tureng" do
    alias About.Translate.Tureng

    test "list_tureng/0 returns all tureng" do
      assert Translate.list_tureng() == []
    end
  end
end
