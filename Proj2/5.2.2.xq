declare function local:extract-month( $date as xs:string ) as xs:string {
	let $sub_mes_ano := substring-after($date, '-')
	let $sub_mes := substring-before($sub_mes_ano, '-')
	return (	if($sub_mes = '')
		then $sub_mes_ano
		else $sub_mes)
};

let $ex1_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_ex1.xml")
let $hmm_out := doc("D:\Francisco\IST\Mestrado\1Ano-1Semestre\Gestao e Tratamento de Informação\Projecto\Parte 2\Exemplo_out_hmm.xml")

let $months := distinct-values (
	(for $date in $ex1_out//item/@date
	return local:extract-month($date),
	for $item in $hmm_out//item
	return $item/date/month))

for $month in $months
return	(
		<result month="{$month}">
			{count(	for $date in (
						for $item in $hmm_out//item
						let $item_date := concat($item/date/day,'-',$item/date/month)
						return $item_date,
						for $date in$ex1_out//item/@date
						return string($date))
				where local:extract-month($date) = $month
				return $date)}
		</result>
	)