defmodule Pho.Repo do
  use Ecto.Repo,
    otp_app: :pho,
    adapter: Ecto.Adapters.MyXQL
end
