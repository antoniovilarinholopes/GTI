
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

let $categories := distinct-values( doc("DN-Ultimas.xml")//item/category)

for $cat in $categories
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
