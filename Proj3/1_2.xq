
declare function local:transitive-closure($politicians, $elementPos) {

let $cluster := ($politicians[$elementPos])

let $tmp:= (for $position in 1 to fn:count($politicians)
	return
		if(local:isSimiliar($politicians[$elementPos], $politicians[$position]))
		then $cluster := ($cluster, local:transitive-closure(remove($politicians, $elementPos), $position-1))
		else())
return $cluster
};

declare function local:isSimiliar($p1, $p2) {
<Fazer_o_Jaccard_aqui />
};

declare function local:getClusters($politicians) {

for $position in 1 to fn:count($politicians)
return
	<cluster>
	{local:transitive-closure($politicians, $position)}
	</cluster>
};
