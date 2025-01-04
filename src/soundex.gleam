import gleam/dict
import gleam/list
import gleam/order
import gleam/regexp
import gleam/result
import gleam/string

const code_lookup_list = [
  #("b", "1"), #("f", "1"), #("p", "1"), #("v", "1"), #("c", "2"), #("g", "2"),
  #("j", "2"), #("k", "2"), #("q", "2"), #("s", "2"), #("x", "2"), #("z", "2"),
  #("d", "3"), #("t", "3"), #("l", "4"), #("m", "5"), #("n", "5"), #("r", "6"),
]

pub fn soundex(name: String) -> Result(String, String) {
  let assert Ok(valid_characters) =
    regexp.from_string("^[a-zA-Z][a-zA-Z0-9\\-_!()' ]*$")
  case regexp.check(valid_characters, name) {
    True -> {
      let assert Ok(first) = string.first(name)
      Ok(calc_soundex_code(name, first))
    }
    False -> Error("INVALID_INPUT")
  }
}

fn calc_soundex_code(original_name: String, first_letter: String) -> String {
  let original_name = string.lowercase(original_name)

  let code_lookup = dict.from_list(code_lookup_list)
  let special_consonants = ["y", "h", "w"]
  let assert Ok(letters_to_remove_regex) = regexp.from_string("[aeiouyhw]")

  let assert Ok(valid_characters) = regexp.from_string("[a-z]")
  let soundex_missing_start =
    string.to_graphemes(original_name)
    |> list.filter(fn(letter) { regexp.check(valid_characters, letter) })
    |> list.map(fn(value: String) {
      dict.get(code_lookup, value) |> result.unwrap(value)
    })
    |> clean_doubles("", "", special_consonants)
    |> string.to_graphemes()
    |> list.filter(fn(x) { !regexp.check(letters_to_remove_regex, x) })
    |> string.join("")

  let soundex_code = case
    regexp.check(letters_to_remove_regex, string.lowercase(first_letter))
  {
    True -> first_letter <> soundex_missing_start

    False -> first_letter <> string.drop_start(soundex_missing_start, 1)
  }
  // make a max 4 letter code padded with zeroes
  soundex_code |> string.slice(0, 4) |> string.pad_end(4, "0")
}

fn clean_doubles(
  word: List(String),
  prev_letter: String,
  result: String,
  special_consonants: List(String),
) -> String {
  case word {
    [head, next, ..tail] -> {
      let retained_letter = return_string_if_no_match(head, prev_letter)
      // special case 
      let remaining_letters = case list.contains(special_consonants, head) {
        True ->
          case string.compare(prev_letter, next) {
            order.Eq -> tail
            _ -> [next, ..tail]
          }
        False -> [next, ..tail]
      }
      clean_doubles(
        remaining_letters,
        retained_letter,
        result <> retained_letter,
        special_consonants,
      )
    }
    [last] -> result <> return_string_if_no_match(last, prev_letter)
    [] -> result
  }
}

fn return_string_if_no_match(head, prev_letter) {
  case string.compare(head, prev_letter) {
    order.Eq -> ""
    _ -> head
  }
}
