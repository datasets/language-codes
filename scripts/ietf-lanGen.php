<?php
/**
 * Extracts all lang codes and basic metadata.
 * @version 2015-08-31
 * @usage php ietf-lanGen.php > data/ietf-language-tags.csv
 */

//CONFIGS:
	$dir= 'main'; // "common/main" obtained from http://www.unicode.org/Public/cldr/latest/core.zip
	$cldrCore_js = 'https://raw.githubusercontent.com/unicode-cldr/cldr-core/master/defaultContent.json';
	// see https://github.com/unicode-cldr/cldr-core


$cldrCore    = json_decode( file_get_contents($cldrCore_js), TRUE );
$cldrCoreDft = array_map( 'strtolower', $cldrCore['defaultContent'] );

$dom = new DOMDocument;
$n=0;

# create ietf-language-tags.csv and assign headers 
$myfile = fopen("data/ietf-language-tags.csv", "w") or die("Unable to open file!");
$txt = "lang,langType,territory,revGenDate,defs,dftLang,file";
fwrite($myfile, $txt);
fclose($myfile);

foreach(scandir($dir) as $file) if (preg_match('/^(.+)\.xml$/',$file,$m)) {
    $lang = $m[1];
    $dom->load("$dir/$file");
    $xp = new DOMXpath($dom);
    $revGenDate = $xp->evaluate("string(/ldml/identity/generation/@date)");
    $langType   = $xp->evaluate("string(/ldml/identity/language/@type)");
    $territory  = $xp->evaluate("string(/ldml/identity/territory/@type)");
    $defs       = $xp->evaluate("count(/ldml/*[not(self::identity)])");
    $revGenDate = preg_replace('/^[^\d]+(\d+\-\d+\-\d+).+$/','$1',$revGenDate);
    $isDftLang  = in_array(strtolower($lang),$cldrCoreDft)? '1': '0'; // yes or not
    $lang = strtr($lang,'_','-');
		
		# open ietf-languange-tags.csv and append data
		$myfile = fopen("data/ietf-language-tags.csv", "a") or die("Unable to open file!");
		$txt = "\n$lang,$langType,$territory,$revGenDate,$defs,$isDftLang,$file";
		fwrite($myfile, $txt);
		fclose($myfile);
		
    //print "\n$lang,$langType,$territory,$revGenDate,$defs,$isDftLang,$file";
    $n++;
}
// print "\n--- END: $n lang codes ---\n";
?>
