<?php
/**
 * Extracts all lang codes and basic metadata of dir.
 * Folder $dir obtained from http://www.unicode.org/Public/cldr/latest/core.zip
 */

$dir= 'main';

$dom = new DOMDocument;
$n=0;
print "lang,langType,territory,revGenDate,defs,file";
foreach(scandir($dir) as $file) if (preg_match('/^(.+)\.xml$/',$file,$m)) {
    $lang = strtr($m[1],'_','-');
    $dom->load("$dir/$file");
    $xp = new DOMXpath($dom);
    $revGenDate = $xp->evaluate("string(/ldml/identity/generation/@date)");
    $langType   = $xp->evaluate("string(/ldml/identity/language/@type)");
    $territory  = $xp->evaluate("string(/ldml/identity/territory/@type)");
    $defs       = $xp->evaluate("count(/ldml/*[not(self::identity)])");
    $revGenDate = preg_replace('/^[^\d]+(\d+\-\d+\-\d+).+$/','$1',$revGenDate);
    print "\n$lang,$langType,$territory,$revGenDate,$defs,$file";
    $n++;
}
//print "\n--- END: $n lang codes ---\n";
?>
