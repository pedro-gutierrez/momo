defmodule Momo.Compare.Neq do
  @moduledoc false
  alias Momo.Compare.Eq

  def compare(values), do: not Eq.compare(values)
end
