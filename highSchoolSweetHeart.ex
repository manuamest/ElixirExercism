defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name
    |> String.trim()
    |> String.first()
  end


  def initial(name) do
    first_letter(name)
    |> String.upcase()
    |> Kernel.<>"."
  end

  def initials(full_name) do
    [name, last_name] = String.split(full_name)
    initial(name) <> " " <> initial(last_name)
  end

  def pair(full_name1, full_name2) do
    "     ******       ******\n   **      **   **      **\n **         ** **         **\n**            *            **\n**                         **\n**     #{initials(full_name1)}  +  #{initials(full_name2)}     **\n **                       **\n   **                   **\n     **               **\n       **           **\n         **       **\n           **   **\n             ***\n              *\n"
  end
end
