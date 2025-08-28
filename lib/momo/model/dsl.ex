defmodule Momo.Model.Dsl do
  use Diesel.Dsl,
    otp_app: :momo,
    root: Momo.Model.Dsl.Model,
    tags: [
      Momo.Model.Dsl.Attribute,
      Momo.Model.Dsl.BelongsTo,
      Momo.Model.Dsl.Unique,
      :key,
      :primary_key,
      Momo.Model.Dsl.OnConflict,
      Momo.Model.Dsl.HasMany
    ]
end
