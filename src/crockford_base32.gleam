import gleam/bit_array
import gleam/int
import gleam/io
import gleam/result
import gleam/string

pub fn encode_with_checksum(bits: BitArray) -> Result(String, EncodingError) {
  //  // pad to make a mulitple of 5
  //  let bits =
  //    bit_array.append(bits, case bit_array.bit_size(bits) % 5 {
  //      0 -> <<>>
  //      oth -> <<0:size({ 5 - oth })>>
  //    })
  //
  //  iterate_bytes(bits, Ok(""))
  todo
}

pub fn encode(bits: BitArray) -> Result(String, EncodingError) {
  // pad to make a mulitple of 5
  let bits =
    bit_array.append(bits, case bit_array.bit_size(bits) % 5 {
      0 -> <<>>
      oth -> <<0:size({ 5 - oth })>>
    })

  iterate_bytes(bits, Ok(""))
}

//TODO: now write a map so we can decode easier, then write the encode with checksum function
pub fn decode(ip: String) -> BitArray {
  // pad to make a mulitple of 5
  let bits =
    bit_array.append(bits, case bit_array.bit_size(bits) % 5 {
      0 -> <<>>
      oth -> <<0:size({ 5 - oth })>>
    })

  iterate_bytes(bits, Ok(""))
}

pub type EncodingError {
  UnexpectedChar(got: Int)
  Impossible(num: Int)
  ImpossibleNumberOfBits(num: BitArray)
}

fn mapping(i: Int) -> Result(String, EncodingError) {
  case i {
    n if n < 10 -> Ok(int.to_string(n))
    10 -> Ok("A")
    11 -> Ok("B")
    12 -> Ok("C")
    13 -> Ok("D")
    14 -> Ok("E")
    15 -> Ok("F")
    16 -> Ok("G")
    17 -> Ok("H")
    18 -> Ok("J")
    19 -> Ok("K")
    20 -> Ok("M")
    21 -> Ok("N")
    22 -> Ok("P")
    23 -> Ok("Q")
    24 -> Ok("R")
    25 -> Ok("S")
    26 -> Ok("T")
    27 -> Ok("V")
    28 -> Ok("W")
    29 -> Ok("X")
    30 -> Ok("Y")
    31 -> Ok("Z")
    oth -> Error(UnexpectedChar(oth))
  }
}

fn iterate_bytes(
  bits: BitArray,
  output: Result(String, EncodingError),
) -> Result(String, EncodingError) {
  case output {
    Error(e) -> {
      Error(e)
    }
    Ok(output) -> {
      case bits {
        <<first:size(5), rest:bits>> -> {
          case first {
            n if n < 0 || n > 31 -> {
              Error(Impossible(n))
            }
            _ -> {
              let first = first |> mapping |> result.unwrap("")
              let output = string.append(output, first)
              iterate_bytes(rest, Ok(output))
            }
          }
        }
        <<>> -> {
          Ok(output)
        }
        e -> {
          Error(ImpossibleNumberOfBits(e))
        }
      }
    }
  }
}

pub fn i() -> Nil {
  bit_array.from_string("hello")
  |> encode
  |> result.unwrap("")
  |> io.println
  //  <<2>> |> echo |> encode |> echo |> result.unwrap("") |> io.println
  //  <<0>> |> echo |> encode |> echo |> result.unwrap("") |> io.println
}
