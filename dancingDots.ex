defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(%{opacity: opacity} = dot, frame_no, _) when rem(frame_no, 4) == 0,
    do: %{dot | opacity: opacity / 2}

  @impl DancingDots.Animation
  def handle_frame(dot, _, _), do: dot
end

defmodule DancingDots.Zoom do
  @behaviour DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    case Keyword.get(opts, :velocity) do
      velocity when is_number(velocity) ->
        {:ok, opts}

      v ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(v)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%{radius: radius} = dot, frame_no, velocity: velocity),
    do: %{dot | radius: radius + (frame_no - 1) * velocity}
end





defmodule DancingDots.Dot do
  defstruct [:x, :y, :radius, :opacity]
  @type t :: %__MODULE__{}
end





defmodule DancingDots.DotGroup do
  # This module is an example of how behaviours can be used in practice.
  # You don't need to read it to solve this exercise.
  # It's here for the curious :)

  @moduledoc """
  Allows applying a list of one or more animations to a group of one or more dots.
  """

  defstruct [:dots, :animations_with_opts]
  @type t :: %__MODULE__{}

  @doc """
  Creates a new dot group with given dots and an empty list of animations.
  """
  @spec new([DancingDots.Dot.t()]) :: t()
  def new(dots) do
    %__MODULE__{
      dots: dots,
      animations_with_opts: []
    }
  end

  @doc """
  Validates the given animation module with its given options and adds it to the group.
  """
  @spec add_animation(t(), module, DancingDots.Animation.opts()) ::
          {:ok, t()} | {:error, DancingDots.Animation.error()}
  def add_animation(dot_group, animation_module, opts) do
    # using Animation's init/1 callback
    init_result = animation_module.init(opts)

    case init_result do
      {:ok, opts} ->
        animations_with_opts = [{animation_module, opts} | dot_group.animations_with_opts]
        dot_group = %{dot_group | animations_with_opts: animations_with_opts}
        {:ok, dot_group}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Applies the list of animations to all the dots.
  """
  @spec render_dots(t(), DancingDots.Animation.frame_number()) :: [DancingDots.Dot.t()]
  def render_dots(dot_group, frame_number) do
    %{
      dots: dots,
      animations_with_opts: animations_with_opts
    } = dot_group

    Enum.map(dots, fn dot ->
      Enum.reduce(animations_with_opts, dot, fn {animation_module, opts}, acc ->
        # using Animation's handle_frame/3 callback
        animation_module.handle_frame(acc, frame_number, opts)
      end)
    end)
  end
end
