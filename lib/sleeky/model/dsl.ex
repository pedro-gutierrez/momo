defmodule Sleeky.Model.Dsl do
  use Diesel.Dsl,
    otp_app: :sleeky,
    root: Sleeky.Model.Dsl.Model,
    tags: [
      Sleeky.Model.Dsl.Attribute,
      Sleeky.Model.Dsl.BelongsTo,
      Sleeky.Model.Dsl.Unique,
      :key,
      :primary_key,
      Sleeky.Model.Dsl.OnConflict,
      Sleeky.Model.Dsl.HasMany
    ]
end
