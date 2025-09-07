defmodule Momo.Enum.Generator.Functions do
  @moduledoc false
  @behaviour Diesel.Generator

  @impl true
  def generate(_enum, _opts) do
    quote do
      @doc """
      Returns all values defined in this enum
      """
      def values do
        Momo.Enum.values(__MODULE__)
      end

      @doc """
      Returns all labels defined in this enum
      """
      def labels do
        Momo.Enum.labels(__MODULE__)
      end

      @doc """
      Returns all value-label pairs as a keyword list
      """
      def options do
        Momo.Enum.options(__MODULE__)
      end

      @doc """
      Finds the label for a given value
      """
      def label_for(value) do
        Momo.Enum.label_for(__MODULE__, value)
      end

      @doc """
      Finds the label for a given value
      """
      def label_for!(value) do
        {:ok, label} = Momo.Enum.label_for(__MODULE__, value)
        label
      end

      @doc """
      Finds the value for a given label
      """
      def value_for(label) do
        Momo.Enum.value_for(__MODULE__, label)
      end

      @doc """
      Checks if a value is valid for this enum
      """
      def valid_value?(value) do
        Momo.Enum.valid_value?(__MODULE__, value)
      end

      @doc """
      Checks if a label is valid for this enum
      """
      def valid_label?(label) do
        Momo.Enum.valid_label?(__MODULE__, label)
      end
    end
  end
end
