defmodule PasswordGeneratorTest do
  use ExUnit.Case
  alias Models.Options

  setup do
    constants = %{
      numbers: Enum.map(0..9, &to_string(&1)),
      lowercase: Enum.map(?a..?z, &<<&1>>),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("~!@#$%^&*()-_=+[{]}|;:,<.>/?", "", trim: true)
    }

    options = %Options{
      length: 20,
      numbers: true,
      uppercase: true,
      symbols: true
    }

    %{constants: constants, options: options}
  end

  test "should give a result with same option length and contains lowercase letters", %{
    constants: constants,
    options: options
  } do
    options = struct(Options, Map.take(options, [:length]))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)

    refute String.contains?(result, constants.numbers)
    refute String.contains?(result, constants.uppercase)
    refute String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase letters and numbers",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.take(options, [:length, :numbers]))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.numbers)

    refute String.contains?(result, constants.uppercase)
    refute String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase and uppercase letters",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.take(options, [:length, :uppercase]))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.uppercase)

    refute String.contains?(result, constants.numbers)
    refute String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase letters and symbols",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.take(options, [:length, :symbols]))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.symbols)

    refute String.contains?(result, constants.numbers)
    refute String.contains?(result, constants.uppercase)
  end

  test "should give a result with same option length and contains lowercase and uppercase letters and numbers",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.delete(options, :symbols))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.numbers)
    assert String.contains?(result, constants.uppercase)

    refute String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase and uppercase letters, numbers and symbols",
       %{
         constants: constants,
         options: options
       } do
    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.numbers)
    assert String.contains?(result, constants.uppercase)
    assert String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase and uppercase letters, numbers and not contains symbols",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.put(options, :symbols, false))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.numbers)
    assert String.contains?(result, constants.uppercase)

    refute String.contains?(result, constants.symbols)
  end

  test "should give a result with same option length and contains lowercase and uppercase letters and symbols and not contains numbers",
       %{
         constants: constants,
         options: options
       } do
    options = struct(Options, Map.put(options, :numbers, false))

    {:ok, result} = PasswordGenerator.generate(options)

    assert 20 = String.length(result)
    assert String.contains?(result, constants.lowercase)
    assert String.contains?(result, constants.uppercase)
    assert String.contains?(result, constants.symbols)

    refute String.contains?(result, constants.numbers)
  end
end
