let $categories := distinct-values( doc("DN-Ultimas.xml")//item/category)

for $cat in $categories
return
<category name="{$cat}">
{
for $item in doc("DN-Ultimas.xml")//item[category=$cat]
let $date := $item/pubDate
order by $date descending
return
	<item date="{$item/pubDate}" title="{$item/title}" link="{$item/link}">
	{$item/description/text()}
	</item>
}
</category>
