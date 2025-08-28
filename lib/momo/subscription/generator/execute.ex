defmodule Momo.Subscription.Generator.Execute do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_subscription, _opts) do
    quote do
      def execute(params), do: Momo.Subscription.execute(__MODULE__, params)
    end
  end
end
