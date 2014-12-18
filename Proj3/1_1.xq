
declare function local:find-politician-pairs($doc) {

let $politicians := $doc//politician
let $politicians_bigrams := local:computeBigrams($politicians)
let $number_of_pols := fn:count($politicians)


let $politicians_jaccard := (for $position in 1 to $number_of_pols

                        return <politician name="{$politicians[$position]/@name}">
                                {if($position = $number_of_pols)
                                then
                                        <jaccard value="0" />
                                else
			
				
                                         (for $positionfront in $position + 1 to $number_of_pols
                               	 return
				
                              	 	<jaccard value="{local:computeJaccard($politicians_bigrams[$position], $politicians_bigrams[$positionfront])}"
                                         	pol1="{$politicians_bigrams[$position]/@name}"
				party1="{$politicians_bigrams[$position]/@party}"
                                        	pol2="{$politicians_bigrams[$positionfront]/@name}"
				party2="{$politicians_bigrams[$positionfront]/@party}" />
                        		)
			}
			 </politician>
			)


let $thresh := 0.5

let $final_politicians := <pairs> {(for $jaccard in $politicians_jaccard//jaccard
			where $jaccard/@value >= 0.5
			return

			<pair>
				<politician name="{$jaccard/@pol1}" party="{$jaccard/@party1}"/>
				<politician name="{$jaccard/@pol2}" party="{$jaccard/@party2}"/>
			</pair>
                        	)} </pairs>

return $final_politicians;

};



declare function local:computeJaccard($politician1, $politician2)  {

let $number_equal_bigrams := fn:count(fn:distinct-values(for $bigram1 in $politician1//bigram, $bigram2 in $politician2//bigram
			where fn:compare($bigram1/@value, $bigram2/@value) = 0
			return 
			$bigram1/@value
			))

let $number_bigrams_pol1 := fn:count(fn:distinct-values(for $bigram1 in $politician1//bigram
			return $bigram1/@value))
let $number_bigrams_pol2 := fn:count(fn:distinct-values(for $bigram2 in $politician2//bigram
			return $bigram2/@value))

let $all_bigrams := (($number_bigrams_pol1 - $number_equal_bigrams) + ($number_bigrams_pol2 - $number_equal_bigrams) + $number_equal_bigrams)

return $number_equal_bigrams div $all_bigrams;

};


declare function local:computeBigrams($politicians)  {

let $pol_bigrams := (for $politician in $politicians
		return 
		<politician name="{$politician/@name}" party="{$politician/@party}">
		{for $position in 1 to fn:string-length($politician/@name)
		  return 
                       if($position = 1) 
		   then
		  	<bigram value="{fn:concat('#', fn:substring($politician/@name, $position, 1))}"/>
			
		   else
			if($position = fn:string-length($politician/@name))
			then				
				(<bigram value="{fn:substring($politician/@name, $position - 1, 2)}"/>,
				<bigram value="{fn:concat(fn:substring($politician/@name,$position, 1), '#')}"/>)
			else
			   	<bigram value="{fn:substring($politician/@name,$position - 1, 2)}"/>	
		}
                     </politician>)
return $pol_bigrams;
};


local:find-politician-pairs(doc("file:///afs/ist.utl.pt/users/2/1/ist173721/GTI/Proj3/Politicians.xml"));