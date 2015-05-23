Comprehensive language code information, consisting of ISO 639-1, ISO 639-2 and IETF language types.

## Data

Data is taken from the [Library of Congress](http://www.loc.gov/standards/iso639-2/iso639-2ra.html) as the ISO 639-2 Registration Authority, and from the [Unicode Common Locale Data Repository](http://cldr.unicode.org/).

### data/language-codes.csv 

This file contains the 184 languages with __ISO 639-1__ (alpha 2 / two letter) codes and their English names.

### data/language-codes-3b2.csv 

This file contains the 184 languages with both __ISO 639-2__ (alpha 3 / three letter) bibliographic codes and ISO 639-1 codes, and their English names.

### data/language-codes-full.csv

This file is more exhaustive.

It contains all languages with __ISO 639-2__ (alpha 3 / three letter) codes, the respective ISO 639-1 codes (if present), as well as the English and French name of each language.

There are two versions of the three letter codes: bibliographic and terminologic. Each language has a bibliographic code but only a few languages have terminologic codes. Terminologic codes are chosen to be similar to the corresponding ISO 639-1 two letter codes.

Example from [Wikipedia](https://en.wikipedia.org/wiki/ISO_639#Relations_between_the_parts):
> [...] the German language (Part 1: `de`) has two codes in Part 2: `ger` (T code) and `deu` (B code), whereas there is only one code in Part 2, `eng`, for the English language.

There are four special codes: *mul*, *und*, *mis*, *zxx*; and a reserved range *qaa-qtz*.

### data/ietf-language-tags.csv

This file lists all IETF language tags of the official resource indicated by http://www.iana.org/assignments/language-tag-extensions-registry 
that into the `/main` folder of http://www.unicode.org/Public/cldr/latest/core.zip (project [cldr.unicode.org](http://cldr.unicode.org)).

## Preparation

This package includes a bash script to fetch current language code information and adjust the formatting.
The file `ietf-language-tags.csv` is obtained with `ietf-lanGen.php`.

## License

This material is licensed by its maintainers under the [Public Domain Dedication and License (PDDL)](http://opendatacommons.org/licenses/pddl/1.0/).

Nevertheless, it should be noted that this material is ultimately sourced from the Library of Congress as a Registration Authority for ISO and their licensing policies are somewhat unclear. As this is a short, simple database of facts, there is a strong argument that no rights can subsist in this collection.

However, if you intended to use these data in a public or commercial product, please check the original sources for any specific restrictions.
