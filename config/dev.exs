use Mix.Config

config :bookex, Bookex.API.Client,
  adapter: Bookex.API.Adapters.Goodreads

config :bookex, Bookex.API.Adapters.Goodreads,
  key: "xs38cKhZadJq60VZilTM1A",
  secret: "bEWSACCN1W8iXFivxsiHyuWJ80HS8HKXu3W4Mh7gQs",
  base_url: "https://www.goodreads.com"
