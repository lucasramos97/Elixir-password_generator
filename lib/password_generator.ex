defmodule PasswordGenerator do
  alias Models.Options

  @list_lowercase_letters Enum.map(?a..?z, &<<&1>>)
  @list_uppercase_letters Enum.map(?A..?Z, &<<&1>>)
  @list_string_numbers Enum.map(0..9, &to_string(&1))
  @list_string_symbols String.split("~!@#$%^&*()-_=+[{]}|;:,<.>/?", "", trim: true)

  def generate(%Options{} = options) do
    result = generate_password(options)

    {:ok, result}
  end

  defp generate_password(%Options{} = options) do
    list = get_list(options)

    generate_password(options, list)
  end

  defp generate_password(%Options{} = options, list) when is_list(list) do
    password =
      Enum.map(1..options.length, fn _ -> Enum.random(list) end)
      |> to_string()

    if contains_all?(options, password) do
      password
    else
      generate_password(options, list)
    end
  end

  defp contains_all?(%Options{} = options, password) when is_bitstring(password) do
    contains_option = %{
      lowercase: String.contains?(password, @list_lowercase_letters),
      numbers: String.contains?(password, @list_string_numbers),
      uppercase: String.contains?(password, @list_uppercase_letters),
      symbols: String.contains?(password, @list_string_symbols)
    }

    contains_all =
      Map.filter(options, fn {_, value} -> value == true end)
      |> Map.keys()
      |> Enum.reduce(true, fn k, acc -> contains_option[k] and acc end)

    contains_all and contains_option.lowercase
  end

  defp get_list(%Options{} = options) do
    list_options = %{
      lowercase: @list_lowercase_letters,
      numbers: @list_string_numbers,
      uppercase: @list_uppercase_letters,
      symbols: @list_string_symbols
    }

    list =
      Map.from_struct(options)
      |> Map.filter(fn {_, value} -> value == true end)
      |> Map.keys()
      |> Enum.reduce([], fn k, acc -> list_options[k] ++ acc end)

    list ++ list_options.lowercase
  end
end
