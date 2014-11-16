declare namespace p = "http://www.parlamento.pt"

declare namespace functx = "http://www.functx.com";

declare function functx:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;

declare function functx:contains-word
  ( $arg as xs:string? ,
    $word as xs:string )  as xs:boolean {

   matches(upper-case($arg),
           concat('^(.*\W)?',
                     upper-case(functx:escape-for-regex($word)),
                     '(\W.*)?$'))
} ;


declare function local:convertDate($date as xs:string?) as xs:string
{

if (compare(substring($date, 9, 3), 'Jan') = 0)
then concat(substring($date,6,2),'-01-',substring($date, 13, 4))
else 
if (compare(substring($date, 9, 3), 'Feb') = 0)
then concat(substring($date,6,2),'-02-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Mar') = 0)
then concat(substring($date,6,2),'-03-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Apr') = 0)
then concat(substring($date,6,2),'-04-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'May') = 0)
then concat(substring($date,6,2),'-05-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Jun') = 0)
then concat(substring($date,6,2),'-06-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Jul') = 0)
then concat(substring($date,6,2),'-07-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Aug') = 0)
then concat(substring($date,6,2),'-08-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Sep') = 0)
then concat(substring($date,6,2),'-09-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Oct') = 0)
then concat(substring($date,6,2),'-10-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Nov') = 0)
then concat(substring($date,6,2),'-11-',substring($date, 13, 4))
else
if (compare(substring($date, 9, 3), 'Dec') = 0)
then concat(substring($date,6,2),'-12-',substring($date, 13, 4))
else ()
} ;



declare function local:parseNews($rss as xs:string) {
let $categories := distinct-values( doc($rss)//item/category)

return <news>
{for $cat in $categories
return
<category name="{$cat}">
{
for $item in doc("DN-Ultimas.xml")//item[category=$cat]
let $date := $item/pubDate
order by $date descending
return
	<item date="{local:convertDate($item/pubDate)}" title="{$item/title}" link="{$item/link}">
	{$item/description/text()}
	</item>
}
</category>
} </news>
};


declare function local:parlamento($parlament, $news, $n as xs:decimal) {

let $words := (for $session in $parlament//p:session/p:speech
let $toks := tokenize($session/text(), '\W+')
for $t in $toks
return $t)


let $totalWords := count(distinct-values($words))
for $item in $news//item
let $result := count(
	for $w in distinct-values($words)
	return if(functx:contains-word($item/text(), $w))
	then $w
	else())
return if(($result div $totalWords) >= $n)
then <item title="{$item/@title}"/>
else()

};

local:parlamento(doc("Parlamento.xml"), local:parseNews("DN-Ultimas.xml"), 10);
