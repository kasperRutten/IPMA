defmodule Pho.ApikeyContext do 
    import Ecto.Query, warn: false
    import Plug.Conn
    alias Pho.Repo
  
    alias Pho.ApikeyContext.Apikey
    alias Pho.UserContext.User
  
    def load_apikeys(%User{} = u), do: u |> Repo.preload([:apikeys])
  
    def list_apikeys do
      Repo.all(Apikey)
    end
  
    def get_apikey!(id), do: Repo.get!(Apikey, id)
  
    def create_apikey(name, %User{} = user) do
        attrs = %{name: name, key: Randomizer.randomizer(30)}
        %Apikey{}
      |> Apikey.create_changeset(attrs, user)
      |> Repo.insert()
    end
  
    def update_apikey(%Apikey{} = apikey, attrs) do
        apikey
      |> Apikey.changeset(attrs)
      |> Repo.update()
    end
  
    def delete_apikey(%Apikey{} = apikey) do
      Repo.delete(apikey)
    end
  
    def change_apikey(%Apikey{} = apikey) do
        Apikey.changeset(apikey, %{})
    end   

    def verify_apikey!(conn, apikeys) do
      keylist = Enum.map(apikeys.apikeys, & &1.key)
      bool = Enum.any?(keylist, fn x -> x == List.first(get_req_header(conn, "apikeytoken")) end)
      {:ok, bool}
    end

    def verify_user!(conn, apikeys, apikey_id) do
      idlist = Enum.map(apikeys.apikeys, & &1.id)
      bool = Enum.any?(idlist, fn x -> x == apikey_id end)
      {:ok, bool}
    end
  end