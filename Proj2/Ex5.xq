
let $hmm_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_hmm.xml")
let $ex1_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_ex1.xml")
let $feed := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\DN-Ultimas.xml")


let $items := (for $item in $hmm_out//item
	let $date := $item/date
	let $description := $feed//item[contains(title/text(), $item/title/text())]/description/text()
	let $category := $feed//item[contains(title/text(), $item/title/text())]/category
	return 	(
		<category name="{$category[1]}">
			<item date="{$date/day}-{$date/month}-2014" title="{$item/title}">
				{$description}
			</item>
		</category>
		), $ex1_out//category)
let $result := (
	<news>
	{for $category_item in distinct-values($items/@name)
	let $var :=	(
				for $cat_item in $items
				order by $cat_item/@date
				where $cat_item/@name = $category_item
				return $cat_item/item
				)
	return 	(
		<category name="{$category_item}">
			{$var}
		</category>
		)}
	</news>
	)
return $result