<a className="gh-badge" href="https://datahub.io/core/language-codes"><img src="https://badgen.net/badge/icon/View%20on%20datahub.io/orange?icon=https://datahub.io/datahub-cube-badge-icon.svg&label&scale=1.25" alt="badge" /></a>

# ISO Language Codes (639-1 and 639-2) and IETF Language Tags

Language codes in four CSV files: the two-letter ISO 639-1 codes, the three-letter ISO 639-2 codes (bibliographic and terminologic) with English and French names, and a list of the IETF language tags that have a locale file in the Unicode CLDR.

Column definitions and types are in `datapackage.json`.

## Data

There are four files in `data/`.

`data/language-codes.csv` has the languages that have a two-letter code, sorted by that code.

| Column | Meaning |
|---|---|
| `alpha2` | ISO 639-1 two-letter code, for example `de` |
| `English` | English name of the language, for example `German` |

`data/language-codes-3b2.csv` has the languages that have both a three-letter bibliographic code and a two-letter code.

| Column | Meaning |
|---|---|
| `alpha3-b` | ISO 639-2 three-letter bibliographic code, for example `ger` |
| `alpha2` | ISO 639-1 two-letter code, for example `de` |
| `English` | English name of the language |

`data/language-codes-full.csv` has every entry of the ISO 639-2 list.

| Column | Meaning |
|---|---|
| `alpha3-b` | ISO 639-2 three-letter bibliographic code, for example `ger` |
| `alpha3-t` | ISO 639-2 three-letter terminologic code, for example `deu`. Empty when the language has no separate terminologic code |
| `alpha2` | ISO 639-1 two-letter code. Empty when the language has none |
| `English` | English name of the language |
| `French` | French name of the language |

Every language has a bibliographic code, but only a few have a terminologic code. For example, German (Part 1: `de`) has two codes in Part 2: `ger` (bibliographic) and `deu` (terminologic). English has only one code in Part 2: `eng`. See how the parts of ISO 639 relate in [Wikipedia](https://en.wikipedia.org/wiki/ISO_639#Relations_between_the_sets).

`data/ietf-language-tags.csv` has one row for each locale file in the Unicode CLDR core data. It does not list every valid language tag.

| Column | Meaning |
|---|---|
| `lang` | [Language tag](https://www.w3.org/International/articles/language-tags/) made from the file name, with `-` instead of `_`, for example `az-Latn-AZ`. The file `root.xml` gives `root` |
| `langType` | Language code, 2 or 3 letters (for example `aa`, `agq`), or `root` |
| `territory` | Country code (for example `DJ`) or CLDR region code (for example `001` for the world, `150` for Europe). Empty when the file has no territory |
| `revGenDate` | Date the file was generated. Always empty, see below |
| `defs` | Number of top-level sections in the file, not counting its identity section |
| `dftLang` | `1` if CLDR lists the locale as the default content of its language (for example `af-ZA` for Afrikaans), `0` otherwise |
| `file` | Name of the CLDR locale file, for example `aa_DJ.xml` |

### Known limitations

* Names in `English` and `French` can hold several names separated by `; ` (for example `Adyghe; Adygei`). Use the codes as keys, not the names.
* The special codes `mul`, `und`, `mis` and `zxx` are in the full file, and so is one row with the code range `qaa-qtz` ("Reserved for local use"). That row is not a normal three-letter code.
* Nearly every `French` name in `language-codes-full.csv` ends with a carriage return (`\r`) inside the quotes. Remove it after reading: `df["French"] = df["French"].str.rstrip("\r")`.
* `territory` in `ietf-language-tags.csv` can be `NA`, the code for Namibia (for example `en-NA`). pandas reads `NA` as a missing value by default. The two-letter language code `na` (Nauru) in the other files is not affected, because pandas only treats upper case `NA` as missing.
* `territory` can also be a three-digit CLDR code with leading zeros (`001`). Read it as text.
* With pandas, read the files as text and keep empty cells empty: `pd.read_csv("data/ietf-language-tags.csv", dtype=str, keep_default_na=False)`. This keeps `NA`, `001` and the empty cells as they are in the file. Without it, `NA` becomes a missing value.
* `dftLang` comes from CLDR's list of default content. A few entries in that list have no locale file in the CLDR core download, so they have no row here.
* `revGenDate` is always empty, because the current CLDR locale files carry no generation date.
* `alpha3-t` and `alpha2` in the full file are empty for many rows. `alpha3-t` is empty unless the language has a terminologic code.

## Data sources

* [ISO 639-2 code list][loc-list], published by the [Library of Congress][loc], the ISO 639-2 Registration Authority. It provides the codes and the English and French names in the three `language-codes` files. Licence: unclear (see [License](#license)).
* [Unicode Common Locale Data Repository (CLDR)][cldr], downloaded as [core.zip][cldr-zip]. It provides the locale file names and a few attributes in `ietf-language-tags.csv`. Licence: [Unicode License v3][unicode-licence]. The notice is in [ATTRIBUTION.txt](ATTRIBUTION.txt).

Changes made to the source data: `language-codes-full.csv` is the ISO 639-2 list split on its field separator into columns, with the names unchanged. `language-codes.csv` keeps only the languages that have a two-letter code, sorted by that code. `language-codes-3b2.csv` keeps only the languages that have both a bibliographic three-letter code and a two-letter code. `ietf-language-tags.csv` has one row for each CLDR locale file: tag, language, territory, generation date, number of definitions, default-language flag and file name. No CLDR names or translations are copied.

Not endorsed by, or affiliated with, the Library of Congress, Unicode, Inc. or ISO.

[loc]: https://www.loc.gov/standards/iso639-2/iso639-2ra.html
[loc-list]: https://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt
[cldr]: https://cldr.unicode.org/
[cldr-zip]: https://www.unicode.org/Public/cldr/latest/core.zip
[unicode-licence]: https://www.unicode.org/license.txt

## Preparation

The scripts need `bash`, `curl`, `awk`, GNU `sed`, `wget`, `unzip` and `php`. The data is rebuilt in the same steps as the GitHub workflow, from the root of the repository:

```
wget https://www.unicode.org/Public/cldr/latest/core.zip
unzip core.zip
mv common/main/ ./
./scripts/language-codes.sh -f
php scripts/ietf-lanGen.php
```

`scripts/language-codes.sh` downloads the Library of Congress list and writes the three `language-codes` files. `scripts/ietf-lanGen.php` reads the locale files in `main/` and writes `data/ietf-language-tags.csv`. It also downloads a list of default locales from the `unicode-cldr/cldr-core` repository to set `dftLang`. The workflow then deletes the CLDR files it unpacked.

A GitHub workflow runs this every Monday at 02:00 UTC, and on every push to `main`. It commits the data files if they changed.

## License

The licence of the ISO 639-2 list is unclear. What we checked:

* The list file and the code list page of the Library of Congress carry no copyright or licence notice, and neither do the Registration Authority page or the FAQ.
* The [Library of Congress legal page](https://www.loc.gov/homepage/legal.html) says that it generally does not own the rights to the materials it shows and that you should decide for yourself whether an item is protected. It does not mention this list.
* ISO states that it "allows free-of-charge use of its country, currency and language codes from ISO 3166, ISO 4217 and ISO 639" (read on an archived copy of the ISO page, December 2024; ISO's current page could not be read). ISO also says that reproducing its materials needs its written permission.

We could not establish whether the full list, with the English and French names, may be republished or used commercially. If you plan commercial use, check the terms of the Library of Congress and ISO first.

`data/ietf-language-tags.csv` is derived from the Unicode CLDR, which is under the [Unicode License v3](https://www.unicode.org/license.txt). That licence allows use, copying and sale if the copyright and permission notice stays with the data. The notice is in [ATTRIBUTION.txt](ATTRIBUTION.txt).

The maintainers place only their own work (the selection and formatting of the data) under the [Public Domain Dedication and License (PDDL)](https://opendatacommons.org/licenses/pddl/1.0/). This does not cover the ISO 639-2 list or the CLDR. See also [ATTRIBUTION.txt](ATTRIBUTION.txt).
