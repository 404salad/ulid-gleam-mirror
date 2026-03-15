import gleam/int
import gleam/result
import gleam/string
import gleam/time/timestamp

@external(erlang, "crypto", "strong_rand_bytes")
pub fn strong_rand_bytes(n: Int) -> BitArray

import crockford_base32

fn unix_ms_now() -> Int {
  let #(sec, ns) =
    timestamp.system_time() |> timestamp.to_unix_seconds_and_nanoseconds()
  let ms = ns / 1000
  sec * 1000 + ms
}

pub fn generated_ulid() -> String {
  let epochs = unix_ms_now()

  // 50 because 5 * 10 (we need 10 chars of 5 bit each in the first half of a ulid)
  let first_part =
    <<epochs:size(50)>> |> crockford_base32.encode |> result.unwrap("")

  // 10*8 = 80  divide by 5 ie 16 chars
  let second_part =
    strong_rand_bytes(10)
    |> crockford_base32.encode
    |> result.unwrap("")

  string.concat([first_part, second_part])
}

pub fn main() -> Nil {
  int.range(1, 10, Nil, fn(_, _: Int) {
    echo generated_ulid()
    Nil
  })

  Nil
  //  io.println("Hello from ulid!")
}
