let $hmm_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_hmm.xml")
let $ex1_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_ex1.xml")

let $items := ($ex1_out//category,
		<category name="Outros">
			{for $item in $hmm_out//item
			 let $date := $item/date
			 order by $date descending
			 return (<item date="{$date/day}-{$date/month}" title="{$item/title}" link="Desconhecido"></item>)
			}
		</category>)

return (	<news>
		{$items}
	</news> )