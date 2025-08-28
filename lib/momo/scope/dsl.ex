defmodule Momo.Scope.Dsl do
  @moduledoc false
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Scope.Dsl.Scope,
    tags: [
      Momo.Scope.Dsl.Eq,
      Momo.Scope.Dsl.Same,
      Momo.Scope.Dsl.Member,
      Momo.Scope.Dsl.Path,
      Momo.Scope.Dsl.One,
      Momo.Scope.Dsl.All,
      Momo.Scope.Dsl.NotNil,
      Momo.Scope.Dsl.IsTrue,
      Momo.Scope.Dsl.IsFalse
    ]
end
