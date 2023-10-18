defmodule DNA do
  @nucleic_space 0b0000
  @nucleic_acid_a 0b0001
  @nucleic_acid_c 0b0010
  @nucleic_acid_g 0b0100
  @nucleic_acid_t 0b1000

  def encode_nucleotide(?\s), do: @nucleic_space
  def encode_nucleotide(?A), do: @nucleic_acid_a
  def encode_nucleotide(?C), do: @nucleic_acid_c
  def encode_nucleotide(?G), do: @nucleic_acid_g
  def encode_nucleotide(?T), do: @nucleic_acid_t

  def decode_nucleotide(@nucleic_space), do: ?\s
  def decode_nucleotide(@nucleic_acid_a), do: ?A
  def decode_nucleotide(@nucleic_acid_c), do: ?C
  def decode_nucleotide(@nucleic_acid_g), do: ?G
  def decode_nucleotide(@nucleic_acid_t), do: ?T


  def encode(dna), do: do_encode(dna, nil)
  defp do_encode([], bts), do: bts
  defp do_encode([c | rest], nil), do: do_encode(rest, <<encode_nucleotide(c)::4>>)
  defp do_encode([c | rest], bts), do: do_encode(rest, <<bts::bitstring, encode_nucleotide(c)::4>>)

  def decode(dna), do: do_decode(dna, [])
  defp do_decode(<<>>, acc), do: reverse_list(acc)
  defp do_decode(<<nucleotide::4, rest::bitstring>>, acc), do: do_decode(rest, [decode_nucleotide(nucleotide) | acc])
  defp reverse_list(list), do: do_reverse_list(list, [])

  defp do_reverse_list([], acc), do: acc
  defp do_reverse_list([nucleotide | rest], acc), do: do_reverse_list(rest, [nucleotide | acc])

end
