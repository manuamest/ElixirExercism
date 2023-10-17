defmodule NameBadge do
  def print(id, name, department) do
    prefix = if id == nil, do: "", else: "[#{id}] - "
    suffix = if department == nil, do: "OWNER", else: String.upcase(department)
    "#{prefix}#{name} - #{suffix}"
  end
end
