defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

    def before_noon?(datetime), do:
    NaiveDateTime.to_time(datetime)
      |> Time.compare(~T[12:00:00]) == :lt

  def return_date(checkout_datetime) do
    if before_noon?(checkout_datetime) do
      checkout_datetime |> NaiveDateTime.to_date() |> Date.add(28)
    else
      checkout_datetime |> NaiveDateTime.to_date() |> Date.add(29)
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    days_diff = Date.diff( NaiveDateTime.to_date(actual_return_datetime), planned_return_date)
    if days_diff <= 0 do 0
    else days_diff
    end
  end

  def monday?(datetime) do
    datetime
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    |> Kernel.==(1)
  end

  def calculate_late_fee(checkout, return, rate) do
    actual_return_datetime = datetime_from_string(return)
    days_late = checkout |> datetime_from_string() |> return_date() |> days_late( actual_return_datetime)
    rate = if monday?(actual_return_datetime), do: 0.5 * rate, else: rate
    trunc(days_late * rate)
  end
end
