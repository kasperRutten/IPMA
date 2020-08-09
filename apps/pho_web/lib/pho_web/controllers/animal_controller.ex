defmodule PhoWeb.AnimalController do
    use PhoWeb, :controller
    import PhoWeb.Plugs.IsWriteable
    alias Pho.UserContext
    alias Pho.AnimalContext
    alias Pho.ApikeyContext
    alias Pho.AnimalContext.Animal
  
    action_fallback PhoWeb.FallbackController
  
    def index(conn, %{"user_id" => user_id}) do
      user = UserContext.get_user!(user_id)
      user_with_loaded_animals = AnimalContext.load_animals(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      case ApikeyContext.verify_apikey!(conn, user_with_loaded_apikeys) do
        {:ok, true} ->
          IO.puts "key is right"
          conn
          |> render("index.json", animals: user_with_loaded_animals.animals)
        {:ok, false} ->
          IO.puts "key is wrong"
          conn
          |> send_resp(400, "Wrong API key.")
        end
    end
  
    def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do
      user = UserContext.get_user!(user_id)
      _user_with_loaded_animals = AnimalContext.load_animals(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      case ApikeyContext.verify_apikey!(conn, user_with_loaded_apikeys) do
        {:ok, true} ->
          IO.puts "key is right"
          conn = ApikeyContext.set_writeable(conn, user_with_loaded_apikeys)
          case ApikeyContext.verify_isWriteable!(conn) do
            {:ok, true} ->
            case AnimalContext.create_animal(animal_params, user) do
              {:ok, %Animal{} = animal} ->
                conn
                |> put_status(:created)
                |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
                |> render("show.json", animal: animal)
      
              {:error, _cs} ->
                conn
                |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
           end
           {:ok, false} ->
            IO.puts "No rights"
            conn
            |> send_resp(400, "No writing permission.")
           end
        {:ok, false} ->
          IO.puts "key is wrong"
          conn
          |> send_resp(400, "Wrong API key.")
        end
    end
  
    def show(conn, %{"user_id" => user_id, "id" => id}) do
      animal = AnimalContext.get_animal!(id)
      user = UserContext.get_user!(user_id)
      _user_with_loaded_animals = AnimalContext.load_animals(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      case ApikeyContext.verify_apikey!(conn, user_with_loaded_apikeys) do
        {:ok, true} ->
          IO.puts "key is right"
          render(conn, "show.json", animal: animal)
        {:ok, false} ->
          IO.puts "key is wrong"
          conn
          |> send_resp(400, "Wrong API key.")
        end
      
    end
  
    def update(conn, %{"user_id" => user_id, "id" => id, "animal" => animal_params}) do
      animal = AnimalContext.get_animal!(id)
      user = UserContext.get_user!(user_id)
      _user_with_loaded_animals = AnimalContext.load_animals(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      case ApikeyContext.verify_apikey!(conn, user_with_loaded_apikeys) do
        {:ok, true} ->
          IO.puts "key is right"
          conn = ApikeyContext.set_writeable(conn, user_with_loaded_apikeys)
          case ApikeyContext.verify_isWriteable!(conn) do
            {:ok, true} ->
            case AnimalContext.update_animal(animal, animal_params) do
              {:ok, %Animal{} = animal} ->
                render(conn, "show.json", animal: animal)
        
              {:error, _cs} ->
                conn
                |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
            end
            {:ok, false} ->
              IO.puts "No rights"
              conn
              |> send_resp(400, "No writing permission.")
            end
        {:ok, false} ->
          IO.puts "key is wrong"
          conn
          |> send_resp(400, "Wrong API key.")
        end
    end
  
    def delete(conn, %{"user_id" => user_id, "id" => id}) do
      animal = AnimalContext.get_animal!(id)
      user = UserContext.get_user!(user_id)
      _user_with_loaded_animals = AnimalContext.load_animals(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      case ApikeyContext.verify_apikey!(conn, user_with_loaded_apikeys) do
        {:ok, true} ->
          conn = ApikeyContext.set_writeable(conn, user_with_loaded_apikeys)
          case ApikeyContext.verify_isWriteable!(conn) do
            {:ok, true} ->
          with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
            send_resp(conn, :no_content, "")
          end
          {:ok, false} ->
            IO.puts "No rights"
            conn
            |> send_resp(400, "No writing permission.")
           end
        {:ok, false} ->
          IO.puts "key is wrong"
          conn
          |> send_resp(400, "Wrong API key.")
        end
    end
  end