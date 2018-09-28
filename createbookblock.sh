#!/bin/sh 

echo uncompressing
pdftk $1 output uncompressed.pdf uncompress
echo stripping annotations
LANG=C sed -n '/^\/Annots/!p' uncompressed.pdf > stripped.pdf
echo recompressing
pdftk stripped.pdf output recompressed.pdf compress
echo conforming to PDF-X/3
gs -dPDFX -dBATCH -dNOPAUSE -dUseCIEColor -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile=x3.pdf recompressed.pdf 

echo stripping cover pages
modulo=4 
#count page numbers
p=$(pdfinfo x3.pdf | grep Pages | sed 's/[^0-9]*//') 
# prepare for removal of backcover
endpage=$(($p - 4))  #remove ad
effectivepages=$(($p - 4)) 
blankpagenumber=$(($p - 3))  
echo blankpagenumber
# compute how many blank pages to add
n=$(($modulo -  $effectivepages % modulo)) 
# start with no blank pages
b=''
#accumulate Bs until we reach a multiple
while [ $n -ne 0 ]; do
  b=$b\ A$blankpagenumber
  n=$(($n - 1))
  done
echo $b 
# strip front and back cover and add blank pages to meet multiple of modulo
echo reassembling
# pdftk A=x3.pdf cat A$blankpagenumber A2-$(($endpage))north $b output Bookblock.pdf
cp x3.pdf Bookblock.pdf
echo cleaning up
rm uncompressed.pdf stripped.pdf recompressed.pdf x3.pdf

