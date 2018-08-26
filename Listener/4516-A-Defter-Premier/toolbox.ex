defmodule Listener4516 do

defp max_value(length) do
  case length do
    2 -> 99
    3 -> 999
    4 -> 9999
    5 -> 99999
    6 -> 999999
    _ -> raise "Unexpected length value given"
  end
end

defp min_value(length) do
  case length do
    2 -> 10
    3 -> 100
    4 -> 1000
    5 -> 10000
    6 -> 100000
    _ -> raise "Unexpected length value given"
  end
end

defp min_result_integer_sum(clue) do
  if rem(clue, 2) == 0 do
    (clue / 2 - 1) * (clue / 2 + 1) |> trunc
  else
    (clue / 2 + 0.5) * (clue / 2 - 0.5) |> trunc
  end
end

defp sums(clue, length) do
  sums_(clue, length, 1) |> filter_valid(length)
end

defp sums_(clue, length, index) do
  if index == clue do
    []
  else
    [(clue-index) * (clue-index) + index * index | sums_(clue, length, index+1)]
  end
end

def primes do
  {:ok, str} = File.read("primes.txt")
  str |> String.split(",")
      |> Enum.map(fn x -> String.to_integer(x) end)
end

defp products(clue, length) do
  all_product_pairs(clue)
  |> multiply_pairs
  |> filter_valid(length)
end

defp all_product_pairs(val) do
  for i <- 1..trunc(val*0.5)+1, rem(val, i) == 0, do: {i, trunc(val/i)}
end

defp filter_valid(vals, length) do
  Enum.filter(vals, fn x -> x >= min_value(length) && x <= max_value(length) end)
  |> Enum.filter(fn x -> Enum.member?(primes, x) end)
end


defp multiply_pairs(pairs) do
  Enum.map(pairs, fn {a, b} -> a*a + b*b end)
end

def possibilities(clue, length) do
    Enum.concat(sums(clue, length), products(clue, length)) |> Enum.uniq
    |> Enum.concat([0])
end

end

defmodule NPrimes do
  def get_primes(n) when n < 2, do: []
  def get_primes(n), do: Enum.filter(2..n, &is_prime?(&1))

  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(x) do
    start_lim = div(x, 2)
    Enum.reduce(2..start_lim, {true, start_lim}, fn(fac, {is_prime, upper_limit}) ->
      cond do
        !is_prime -> {false, fac}
        fac > upper_limit -> {is_prime, upper_limit}
        true ->
          is_prime = rem(x, fac) != 0
          upper_limit = if is_prime, do: div(x, fac + 1), else: fac
          {is_prime , upper_limit}
      end
    end) |> elem(0)
  end
end
