# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end
defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> {1, []} end, opts)
  end
  def list_registrations(pid) do
    Agent.get(pid, fn {_next_plot_id, state} -> state end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(
      pid,
      fn {next_plot_id, state} ->
        new_plot = %Plot{plot_id: next_plot_id, registered_to: register_to}
        {new_plot, {next_plot_id + 1, [new_plot | state]}}
      end
    )
  end
  def release(pid, plot_id) do
    Agent.update(pid, fn {seq, list} ->
      {seq, Enum.filter(list, &(&1.plot_id != plot_id))}
    end)
  end
  def get_registration(pid, plot_id) do
    case list_registrations(pid) |> Enum.find(&(&1.plot_id == plot_id)) do
      nil -> {:not_found, "plot is unregistered"}
      reg -> reg
    end
  end
end
