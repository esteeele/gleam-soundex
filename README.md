# soundex

Implementation of the [soundex](https://en.wikipedia.org/wiki/Soundex) algorithm for matching words (usually names) based on phonetic similarity in spoken English.

[![Package Version](https://img.shields.io/hexpm/v/soundex)](https://hex.pm/packages/soundex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/soundex/)

```sh
gleam add soundex@1
```
```gleam
import soundex

pub fn main() {
  let assert Ok(soundex_code_1) = soundex.soundex("Harry Seldon")
  let assert Ok(soundex_code_2) = soundex.soundex("Hari Seldon")
  // these will be the same code
}
```

Further documentation can be found at <https://hexdocs.pm/soundex>.

## Development

```sh
gleam test  # Run the tests
```
