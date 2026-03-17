defmodule Momo.Subscription.Parser do
  @moduledoc false
  @behaviour Diesel.Parser

  alias Momo.Subscription

  import Momo.Naming

  def parse({:subscription, attrs, _children}, opts) do
    name = Keyword.fetch!(opts, :caller_module)
    caller = Keyword.fetch!(opts, :caller_module)
    app = app(caller)

    event = Keyword.fetch!(attrs, :on)
    action = Keyword.get(attrs, :perform)

    %Subscription{
      name: name,
      app: app,
      event: event,
      action: action
    }
  end
end
