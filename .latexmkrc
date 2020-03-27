#!/usr/bin/env perl

$latex            = 'platex -synctex=1 -halt-on-error -file-line-error %O %S';
$latex_silent     = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex %O %S';
$biber            = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode         = 3;
$pvc_view_file_via_temporary = 0;
$pdf_previewer    = "open -ga /Applications/Skim.app";
$clean_full_ext   = "%R.synctex.gz"
