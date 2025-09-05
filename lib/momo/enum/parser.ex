defmodule Momo.Enum.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Enum
  alias Momo.Enum.Value

  def parse({:enum, _attrs, children}, opts) do
    name = Keyword.fetch!(opts, :caller_module)

    values =
      for {:value, attrs, _} <- children do
        %Value{
          value: Keyword.fetch!(attrs, :name),
          label: Keyword.fetch!(attrs, :label)
        }
      end

    %Enum{
      name: name,
      values: values
    }
  end
end
