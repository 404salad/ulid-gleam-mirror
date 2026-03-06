import crockford_base32
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

pub fn crockford_encode_test() {
  assert crockford_base32.encode(<<>>) == Ok("")
  assert crockford_base32.encode(<<0>>) == Ok("00")
}
