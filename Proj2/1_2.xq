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

for $session in $parlament//p:session
let $sessionSpeeches := concat(for $speech in $session/p:speech
		return ($speech/text(), ' '))
return 
	<session>
	{
	for $news_item in $news//item
	let $news_item_copy := $news_item
	let $result := local:match(concat($news_item/text(), ' ', $news_item/@title), $sessionSpeeches)
	return if(($result div count(distinct-values(tokenize($sessionSpeeches, '\W+')))) >= $n)
		then <item title='{$news_item_copy/@title}' />
		else()
	}
	</session>
};

declare function local:match($arg1, $arg2) {
let $arg1Words := distinct-values(tokenize(lower-case($arg1), '\W+'))
let $arg2Words := distinct-values(tokenize(lower-case($arg2), '\W+'))

return count(for $w in $arg1Words
where $w = $arg2Words
return $w)
};


local:parlamento(doc("Parlamento.xml"), local:parseNews("DN-Ultimas.xml"), 1);
(:local:match("the the ola", "the teste ola");:)
