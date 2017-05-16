defmodule Conekta.Client do
  import Conekta.Wrapper
  alias Conekta.Wrapper

  def get_request(url) do
    get(url)
  end

  def post_request(url) do
    post(url, [])
  end

  def post_request(url, params) do
    post(url, encode_params(params))
  end  

  def encode_params(param) when is_map(param) do
    param
      |> Map.from_struct
      |> Enum.reject(fn{_key, value} ->
        case value do
          nil -> true
          [] -> true
          [%{}] -> true
          _ -> false
        end
      end)
  end




end
