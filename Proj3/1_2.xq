
declare function local:transitive-closure($politicians, $elementPos) {

let $element := $politicians[$elementPos]
let $cluster := ($element)
let $politicians2 := remove($politicians, $elementPos)

let $tmp:= (for $position in 1 to fn:count($politicians2)
	return
		if(local:isSimiliar($element/text(), $politicians2[$position]/text()))
		then $cluster := ($cluster, local:transitive-closure($politicians2, $position))
		else())
return $cluster
};

declare function local:isSimiliar($p1, $p2) {
substring($p1,1,1) = substring($p2,1,1)
};

declare function local:getClusters($politicians) {

for $position in 1 to fn:count($politicians)
return
	<cluster>
	{local:transitive-closure($politicians, $position)}
	</cluster>
};


local:transitive-closure((<e>a1</e>, <e>a2</e>, <e>b1</e>, <e>c1</e>, <e>a3</e>, <e>b2</e>, <e>c2</e>, <e>a4</e>), 1);
