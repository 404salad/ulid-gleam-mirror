import gleam/bit_array
import gleam/int
import gleam/list
import gleam/result
import gleam/string

//pub fn encode_with_checksum(bits: BitArray) -> Result(String, EncodingError) {
//  // pad to make a mulitple of 5
//  let bits =
//    bit_array.append(bits, case bit_array.bit_size(bits) % 5 {
//      0 -> <<>>
//      oth -> <<0:size({ 5 - oth })>>
//    })
//
//  iterate_bytes(bits, Ok(""))
//  todo
//}

pub fn encode(bits: BitArray) -> Result(String, EncodingError) {
  // pad to make a mulitple of 5
  let bits =
    bit_array.append(bits, case bit_array.bit_size(bits) % 5 {
      0 -> <<>>
      oth -> <<0:size({ 5 - oth })>>
    })

  iterate_bytes(bits, Ok(""))
}

fn process_char(c: String) -> Int {
  // example operation
  case c {
    "I" | "L" | "1" -> 1
    "2" -> 2
    "3" -> 3
    "4" -> 4
    "5" -> 5
    "6" -> 6
    "7" -> 7
    "8" -> 8
    "9" -> 9
    "A" -> 10
    "B" -> 11
    "C" -> 12
    "D" -> 13
    "E" -> 14
    "F" -> 15
    "G" -> 16
    "H" -> 17
    "J" -> 18
    "K" -> 19
    "M" -> 20
    "N" -> 21
    "P" -> 22
    "Q" -> 23
    "R" -> 24
    "S" -> 25
    "T" -> 26
    "V" -> 27
    "W" -> 28
    "X" -> 29
    "Y" -> 30
    "Z" -> 31
    _ -> panic as "impossible"
    // TODO: DecodeError
  }
}

fn acc(ip: List(BitArray), sum: BitArray) -> BitArray {
  case ip {
    [head, ..tail] -> acc(tail, bit_array.append(sum, head))
    [] -> sum
  }
}

pub fn print_bytes(bits: BitArray) {
  case bits {
    <<byte:size(8), rest:bits>> -> {
      echo byte
      print_bytes(rest)
    }
    rest -> {
      echo rest
    }
  }
}

// TODO: now write a map so we can decode easier, then write the encode with checksum function
pub fn decode(ip: String) -> BitArray {
  ip
  |> string.uppercase
  |> string.to_graphemes
  |> list.map(process_char)
  |> list.map(fn(i) { <<i:5>> })
  |> acc(<<>>)
  |> bit_array.pad_to_bytes
  |> trim_right_zeros
}

fn trim_right_zeros(bits: BitArray) -> BitArray {
  let s = bit_array.bit_size(bits)
  case bits {
    <<rest:bits-size(s - 8), 0:8>> -> trim_right_zeros(rest)
    _ -> bits
  }
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
  |> result.unwrap(".")
  |> decode
  Nil
}
