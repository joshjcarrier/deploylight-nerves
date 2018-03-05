defmodule Deploylight do
  @pin_num 18 # GPIO18 + GND
  @vsts_collection 'yammer'
  @vsts_project 'notifications-domain'
  @vsts_release_id 3
  @vsts_personal_access_token '' # base64(username:password)
  @poll_interval_sec 30
  def start do
    headers = ["Authorization": "Basic #{@vsts_personal_access_token}", "Accept": "application/json;api-version=4.1-preview.6;excludeUrls=true"]
    response = HTTPoison.get! "https://#{@vsts_collection}.vsrm.visualstudio.com/#{@vsts_project}/_apis/Release/releases?definitionId=#{@vsts_release_id}&definitionEnvironmentId=0&queryOrder=0&%24top=10&%24expand=10&propertySelectors=%5B%7B%22selectorType%22%3A0%2C%22properties%22%3A%5B%22Id%22%2C%22Status%22%2C%22Name%22%2C%22Reason%22%2C%22KeepForever%22%2C%22ReleaseDefinition%22%2C%22CreatedOn%22%2C%22CreatedBy%22%2C%22ModifiedOn%22%2C%22ModifiedBy%22%2C%22Artifacts%22%2C%22Environments%22%2C%22Description%22%2C%22Environments.Name%22%2C%22Environments.Id%22%2C%22Environments.ScheduledDeploymentTime%22%2C%22Environments.Status%22%2C%22Environments.DeploySteps%22%2C%22Environments.ReleaseId%22%2C%22Environments.PreDeployApprovals%22%2C%22Environments.PostDeployApprovals%22%2C%22Environments.ReleaseDefinition%22%2C%22Environments.NextScheduledUtcTime%22%5D%7D%2C%7B%22selectorType%22%3A1%2C%22properties%22%3A%5B%22Environments.PreDeployApprovals.Url%22%2C%22Environments.PreDeployApprovals.Release.Url%22%2C%22Environments.PreDeployApprovals.ReleaseDefinition.Url%22%2C%22Environments.PostDeployApprovals.Url%22%2C%22Environments.PostDeployApprovals.Release.Url%22%2C%22Environments.PostDeployApprovals.ReleaseDefinition.Url%22%5D%7D%5D&isDeleted=false", headers

    payload = response
    |> Map.get(:body)
    |> Poison.decode!

    pending = payload
    |> Map.get("value")
    |> List.first
    |> Map.get("environments")
    |> Enum.flat_map(fn env -> Map.get(env, "deploySteps") end)
    |> Enum.any?(fn ds -> Map.get(ds, "operationStatus") == "ManualInterventionPending" && Map.get(ds, "status") == "inProgress" end)

    deployed = payload
    |> Map.get("value")
    |> List.first
    |> Map.get("environments")
    |> Enum.map(fn env -> Map.get(env, "status") end)
    |> Enum.all?(fn s -> s == "succeeded" end)
    
    deployed
  end  
end

defmodule Deploylight.Blinker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, :ok, args)
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  alias Nerves.Leds

  @on_duration 200
  @off_duration 200

  def init(:ok) do
    led_list = [:green] #Application.get_env(:hello_leds, :led_list)
    # Logger.debug("list of leds to blink is #{inspect(led_list)}")
    Enum.each(led_list, &start_blink(&1))
    {:ok, %{}}
  end

  # Set led `led_key` to the state defined below. It is also possible
  # to globally define states in `config/config.exs` by passing a list
  # of states with the `:states` keyword.
  #
  # The first parameter must be an atom.
  @spec start_blink(Keyword.T) :: true
  defp start_blink(led_key) do
    # Logger.debug("blinking led #{inspect(led_key)}")
    # led_key is a variable that contains an atom
    Leds.set([
      {
        led_key,
        [
          trigger: "timer",
          delay_off: @off_duration,
          delay_on: @on_duration
        ]
      }
    ])
  end
end
