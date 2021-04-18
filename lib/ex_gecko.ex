defmodule ExGecko do
  @moduledoc """
  Documentation for `ExGecko`.

  It's an adapter for CoinGecko: cryptocurrency prices and market capitalization.

  More information: [Explore API](https://www.coingecko.com/en/api#explore-api)
  """
  alias ExGecko.HttpClient

  @type error :: {:error, {:http_error | :request_error, String.t()}}

  @spec ping() :: :ok | error
  def ping do
    HttpClient.get("ping")
    |> case do
      {:ok, _response} -> :ok
      error -> error
    end
  end

  @type simple_price_params :: %{
          required(:ids) => String.t(),
          required(:vs_currencies) => String.t(),
          optional(:include_market_cap) => boolean(),
          optional(:include_24hr_vol) => boolean(),
          optional(:include_24hr_change) => boolean(),
          optional(:include_last_updated_at) => boolean()
        }

  @spec simple_price(simple_price_params) :: {:ok, any()} | error
  def simple_price(params) do
    HttpClient.get("simple/price", params)
  end

  @type simple_token_price_params :: %{
          required(:id) => String.t(),
          required(:contract_addresses) => String.t(),
          required(:vs_currencies) => String.t(),
          optional(:include_market_cap) => boolean(),
          optional(:include_24hr_vol) => boolean(),
          optional(:include_24hr_change) => boolean(),
          optional(:include_last_updated_at) => boolean()
        }

  @spec simple_token_price(simple_token_price_params) :: {:ok, any()} | error
  def simple_token_price(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("simple/token_price/#{id}", params)
  end

  @spec simple_supported_vs_currencies() :: {:ok, list(String.t())} | error
  def simple_supported_vs_currencies do
    HttpClient.get("simple/supported_vs_currencies")
  end

  @type coins_list_params :: %{
          optional(:include_platform) => boolean()
        }

  @spec coins_list() :: {:ok, list(map())} | error
  @spec coins_list(coins_list_params) :: {:ok, list(map())} | error
  def coins_list do
    coins_list(%{})
  end

  def coins_list(params) do
    HttpClient.get("coins/list", params)
  end

  @type coins_markets_params :: %{
          required(:vs_currency) => String.t(),
          optional(:ids) => String.t(),
          optional(:category) => String.t(),
          optional(:order) => String.t(),
          optional(:per_page) => pos_integer(),
          optional(:page) => pos_integer(),
          optional(:sparkline) => boolean(),
          optional(:price_change_percentage) => String.t()
        }

  @spec coins_markets(coins_markets_params) :: {:ok, any()} | error
  def coins_markets(params) do
    HttpClient.get("coins/markets", params)
  end

  @type coins_params :: %{
          required(:id) => String.t(),
          optional(:localization) => String.t(),
          optional(:tickers) => boolean(),
          optional(:market_data) => boolean(),
          optional(:community_data) => boolean(),
          optional(:developer_data) => boolean(),
          optional(:sparkline) => boolean()
        }

  @spec coins(coins_params) :: {:ok, map()} | error
  def coins(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}", params)
  end

  @type coins_tickers_params :: %{
          required(:id) => String.t(),
          optional(:exchange_ids) => String.t(),
          optional(:include_exchange_logo) => String.t(),
          optional(:page) => non_neg_integer(),
          optional(:order) => String.t(),
          optional(:depth) => String.t()
        }

  @spec coins_tickers(coins_tickers_params) :: {:ok, map()} | error
  def coins_tickers(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/tickers", params)
  end

  @type coins_history_params :: %{
          required(:id) => String.t(),
          required(:date) => String.t(),
          optional(:localization) => String.t()
        }

  @spec coins_history(coins_history_params) :: {:ok, map()} | error
  def coins_history(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/history", params)
  end

  @type coins_market_chart_params :: %{
          required(:id) => String.t(),
          required(:vs_currency) => String.t(),
          required(:days) => pos_integer(),
          optional(:interval) => String.t()
        }

  @spec coins_market_chart(coins_market_chart_params) :: {:ok, map()} | error
  def coins_market_chart(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/market_chart", params)
  end

  @type coins_market_chart_range_params :: %{
          required(:id) => String.t(),
          required(:vs_currency) => String.t(),
          required(:from) => String.t(),
          required(:to) => String.t()
        }

  @spec coins_market_chart_range(coins_market_chart_range_params) :: {:ok, map()} | error
  def coins_market_chart_range(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/market_chart/range", params)
  end

  @type coins_status_updates_params :: %{
          required(:id) => String.t(),
          optional(:per_page) => pos_integer(),
          optional(:page) => non_neg_integer()
        }

  @spec coins_status_updates(coins_status_updates_params) :: {:ok, map()} | error
  def coins_status_updates(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/status_updates", params)
  end

  @type coins_ohlc_params :: %{
          required(:id) => String.t(),
          required(:vs_currency) => String.t(),
          optional(:days) => pos_integer()
        }

  @spec coins_ohlc(coins_ohlc_params) :: {:ok, map()} | error
  def coins_ohlc(params = %{id: id}) do
    params = Map.delete(params, :id)

    HttpClient.get("coins/#{id}/ohlc", params)
  end

  @type contract_params :: %{
          required(:id) => String.t(),
          required(:contract_address) => String.t()
        }

  @spec contract(contract_params) :: {:ok, map()} | error
  def contract(%{id: id, contract_address: contract_address}) do
    HttpClient.get("coins/#{id}/contract/#{contract_address}")
  end

  @type contract_market_chart_params :: %{
          required(:id) => String.t(),
          required(:contract_address) => String.t(),
          required(:vs_currency) => String.t(),
          required(:days) => String.t()
        }

  @spec contract_market_chart(contract_market_chart_params) :: {:ok, map()} | error
  def contract_market_chart(params = %{id: id, contract_address: contract_address}) do
    params =
      params
      |> Map.delete(:id)
      |> Map.delete(:contract_address)

    HttpClient.get("coins/#{id}/contract/#{contract_address}/market_chart", params)
  end
end
