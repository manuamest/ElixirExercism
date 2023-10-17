defmodule LogParser do
  def valid_line?(line) do
    String.match?(line, ~r/^\[(DEBUG|INFO|ERROR|WARNING)/)
  end
  def split_line(line) do
    String.split(line, ~r/<[~*=-]*>/)
  end
  def remove_artifacts(line) do
    String.replace(line, ~r/(end-of-line[0-9]+)/i, "")
  end
  def tag_with_user_name(line) do
    matches = Regex.run(~r/User[ \n\t]*(\S*)/, line)
    if matches do
      [_, name] = matches
      "[USER] #{name} #{line}"
    else
      line
    end
  end
end
