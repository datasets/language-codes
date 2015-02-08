Comprehensive language code information, consisting of ISO639-2 and ISO639-1.
 
## Data

Data is taken from the [Library of Congress](http://www.loc.gov/standards/iso639-2/iso639-2ra.html)
as ISO 639-2 Registration Authority.

### data/language-codes.csv 

This file contains the 184 languages with an  __ISO 639-1__ (alpha 2 / two letter) code and their English name. 

### data/language-codes-full.csv 

This file is more exhaustive. 

It contains all languages with __ISO 639-2__ ( alpha 3 / three letter) codes, the respective ISO 639-1 code (if present), as well as English and French name of the language.

There is two versions of the three letter codes: bibliographic and terminologic. There is a bibliographic code for each language and only a few languages with a terminologic code.
The terminologic code is chosen to be similar to the 2 letter code. 

example from [Wikipedia](https://en.wikipedia.org/wiki/ISO_639#Relations_between_the_parts):
> the German language (2-letter: de) has two codes in Part 2: ger (T code) and deu (B code), whereas there is only one code in Part 2, eng, for the English language.

There are four special codes *mul*, *und*, *mis*, *zxx*, and a reserved range *qaa-qtz*
 
## Preparation

This package includes a small bash script to fetch current language code information
and adjust the formatting.

## License

This material is licensed by its maintainers under the Public Domain Dedication
and License.

Nevertheless, it should be noted that this material is ultimately sourced from
the Library of Congress as Registration Authority for ISO and their licensing policies are somewhat
unclear. As this is a short, simple database of facts there is a strong argument
that no rights can subsist in this collection. 

However, if you intended to use these data in a public or commercial product, please
check the original sources for any specific restrictions.

