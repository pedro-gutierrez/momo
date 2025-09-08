defmodule Momo.Enum do
  @moduledoc """
  A DSL to define enums with values and labels
  """

  use Diesel,
    otp_app: :momo,
    dsl: Momo.Enum.Dsl,
    parser: Momo.Enum.Parser,
    generators: [
      Momo.Enum.Generator.Metadata,
      Momo.Enum.Generator.Functions
    ]

  defmodule Value do
    @moduledoc false
    defstruct [:value, :label]
  end

  defstruct [:name, :values]

  @doc """
  Returns all values defined in the enum
  """
  def values(enum) do
    Enum.map(enum.enum_values(), & &1.value)
  end

  @doc """
  Returns all labels defined in the enum
  """
  def labels(enum) do
    Enum.map(enum.enum_values(), & &1.label)
  end

  @doc """
  Returns all value-label pairs as a keyword list
  """
  def options(enum) do
    Enum.map(enum.enum_values(), &{&1.label, &1.value})
  end

  @doc """
  Finds the label for a given value
  """
  def label_for(enum, value) do
    case Enum.find(enum.enum_values(), &(&1.value == value)) do
      %Value{label: label} -> {:ok, label}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Finds the value for a given label
  """
  def value_for(enum, label) do
    case Enum.find(enum.enum_values(), &(&1.label == label)) do
      %Value{value: value} -> {:ok, value}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Checks if a value is valid for this enum
  """
  def valid_value?(enum, value) do
    Enum.any?(enum.enum_values(), &(&1.value == value))
  end

  @doc """
  Checks if a label is valid for this enum
  """
  def valid_label?(enum, label) do
    Enum.any?(enum.enum_values(), &(&1.label == label))
  end
end
