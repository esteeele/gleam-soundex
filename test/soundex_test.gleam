import gleam/dict
import gleam/result
import gleeunit
import gleeunit/should
import soundex

pub fn main() {
  gleeunit.main()
}

pub fn soundex_test() {
  let test_cases =
    [
      #("Robert", "R163"),
      #("Rupert", "R163"),
      #("Rubin", "R150"),
      #("Ashcraft", "A261"),
      #("Ashcroft", "A261"),
      #("Tymczak", "T522"),
      #("Pfister", "P236"),
      #("Honeyman", "H555"),
      #("Jama'a", "J500"),
      #("Gauss", "G200"),
      #("Heilbronn", "H416"),
      #("Lissajous", "L222"),
      #("Mohammed", "M530"),
      #("Muhammed", "M530"),
      #("Harry Seldon", "H624"),
      #("Hari Seldon", "H624"),
      #("ç∫h∂ƒ∑", ""),
    ]
    |> dict.from_list
  dict.each(test_cases, fn(name, expected_value) {
    let soundex_code = soundex.soundex(name) |> result.unwrap("")
    should.equal(soundex_code, expected_value)
  })
}

pub fn error_if_name_empty_test() {
  let soundex_code = soundex.soundex("")
  should.equal(soundex_code, Error("INVALID_INPUT"))
}

pub fn error_if_non_english_test() {
  let soundex_code = soundex.soundex("Danny 王")
  should.equal(soundex_code, Error("INVALID_INPUT"))
}
