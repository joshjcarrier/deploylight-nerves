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
