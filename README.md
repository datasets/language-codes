<a className="gh-badge" href="https://datahub.io/core/language-codes"><img src="https://badgen.net/badge/icon/View%20on%20datahub.io/orange?icon=https://datahub.io/datahub-cube-badge-icon.svg&label&scale=1.25" alt="badge" /></a>

## Description

Comprehensive language code information, consisting of ISO 639-1, ISO 639-2 and IETF language types.

## Data

Data is taken from the [Library of Congress](http://www.loc.gov/standards/iso639-2/iso639-2ra.html) as the ISO 639-2 Registration Authority, and from the [Unicode Common Locale Data Repository](http://cldr.unicode.org/).

### data/language-codes.csv 

This file contains the 183 languages with __ISO 639-1__ (alpha 2 / two letter) codes and their English names.

### data/language-codes-3b2.csv 

This file contains the 183 languages with both __ISO 639-2__ (alpha 3 / three letter) bibliographic codes and ISO 639-1 codes, and their English names.

### data/language-codes-full.csv

This file is more exhaustive.

It contains all languages with __ISO 639-2__ (alpha 3 / three letter) codes, the respective ISO 639-1 codes (if present), as well as the English and French name of each language.

There are two versions of the three letter codes: bibliographic and terminologic. Each language has a bibliographic code but only a few languages have terminologic codes. Terminologic codes are chosen to be similar to the corresponding ISO 639-1 two letter codes.

For example, the German language (Part 1: `de`) has two codes in Part 2: `ger` (bibliographic) and `deu` (terminologic). English has only one code in Part 2: `eng`. See the section on how the ISO 639 parts relate in [Wikipedia](https://en.wikipedia.org/wiki/ISO_639#Relations_between_the_sets).

There are four special codes: *mul*, *und*, *mis*, *zxx*; and a reserved range *qaa-qtz*.

### data/ietf-language-tags.csv

This file lists the 1,122 locale files found in the [Unicode CLDR](http://cldr.unicode.org) core data. For each one it gives the [language tag](https://www.w3.org/International/articles/language-tags/), language, territory and file name. It does not list every valid language tag.

## Preparation

This dataset is automatically updated via GitHub Actions, running scripts to gather `ietf-language-tags.csv` and the various `language-codes` files.

## License

`data/ietf-language-tags.csv` is derived from the Unicode Common Locale Data Repository (CLDR). It is under the [Unicode License v3](https://www.unicode.org/license.txt). The copyright and permission notice is in [ATTRIBUTION.txt](ATTRIBUTION.txt).

The three `data/language-codes*.csv` files come from the Library of Congress ISO 639-2 list. The reuse terms of that list are UNCLEAR. We found no licence on the list itself, on its code-list page, on the Registration Authority page or in its FAQ. ISO says its language codes can be used free of charge. That does not clearly cover republishing the list with the language names. We could not establish more than this.

The maintainers of this repository place their own work, the selection and formatting of the data, under the [Public Domain Dedication and License (PDDL)](http://opendatacommons.org/licenses/pddl/1.0/). This covers nothing more.

If you intend to use these data in a public or commercial product, please check the original sources for any specific restrictions.
