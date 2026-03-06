import crockford_base32
import gleam/bit_array
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn crockford_encode_no_checksum_test() {
  assert crockford_base32.encode(<<>>) == Ok("")
  assert crockford_base32.encode(<<0>>) == Ok("00")

  // generate using https://www.base64.sh/crockford32/
  assert bit_array.from_string("hello") |> crockford_base32.encode
    == Ok("D1JPRV3F")

  assert bit_array.from_string("dvorjak") |> crockford_base32.encode
    == Ok("CHV6YWKAC5NG")
}

pub fn wierd_crockford_encode_test() {
  assert bit_array.from_string("dvorjakBԥ") |> crockford_base32.encode
    == Ok("CHV6YWKAC5NM5N55")
}
