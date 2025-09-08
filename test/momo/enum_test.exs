defmodule Momo.EnumTest do
  use ExUnit.Case

  alias Blogs.Accounts.Enums.CredentialType

  describe "values/0" do
    test "returns all values" do
      assert CredentialType.values() == [1, 2]
    end

    test "returns options as keyword list" do
      assert CredentialType.options() == [{"Password", 1}, {"Pin", 2}]
    end

    test "finds label for valid value" do
      assert {:ok, "Password"} = CredentialType.label_for(1)
      assert {:ok, "Pin"} = CredentialType.label_for(2)
    end

    test "returns error for invalid value" do
      assert {:error, :not_found} = CredentialType.label_for(3)
    end

    test "finds value for valid label" do
      assert {:ok, 1} = CredentialType.value_for("Password")
      assert {:ok, 2} = CredentialType.value_for("Pin")
    end

    test "returns error for invalid label" do
      assert {:error, :not_found} = CredentialType.value_for("Email")
    end

    test "validates values" do
      assert CredentialType.valid_value?(1) == true
      assert CredentialType.valid_value?(2) == true
      assert CredentialType.valid_value?(3) == false
    end

    test "validates labels" do
      assert CredentialType.valid_label?("Password") == true
      assert CredentialType.valid_label?("Pin") == true
      assert CredentialType.valid_label?("Email") == false
    end
  end
end
