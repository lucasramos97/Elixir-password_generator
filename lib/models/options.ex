defmodule Models.Options do
  @enforce_keys [:length]
  defstruct [:length, :numbers, :uppercase, :symbols]
end

defimpl Enumerable, for: Models.Options do
  def count(map) do
    {:ok, map_size(map)}
  end

  def member?(map, {key, value}) do
    {:ok, match?(%{^key => ^value}, map)}
  end

  def member?(_map, _other) do
    {:ok, false}
  end

  def slice(map) do
    size = map_size(map)
    {:ok, size, &Enumerable.List.slice(:maps.to_list(map), &1, &2, size)}
  end

  def reduce(map, acc, fun) do
    Enumerable.List.reduce(:maps.to_list(map), acc, fun)
  end
end
