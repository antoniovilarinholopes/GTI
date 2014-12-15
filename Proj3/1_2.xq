
(:declare function local:transitive-closure($politicians, $elementPos) {

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
}; :)


declare function local:processClusterList($clusters) {

for $position in 1 to fn:count($clusters)

} ;

(: returns a new cluster as a result of joining with the rest of the clusters :)
declare function local:processCluster($clusters, $clusterPosition) {
for $position in 1 to fn:count($clusters)
return
	if(not($position = $clusterPosition))
	then
		if(local:isSimiliarClusters($clusters[$position], $clusters[$position+1]))
		then ($clusters[$position], $clusters[$position+1])
		else()
	else()	
};

(: a cluster is similiar with another if it has at least one element equals :)
declare function local:isSimiliarClusters($cluster1, $cluster2) {

let $commonElements := 
	(for $element1 in $cluster1//p, $element2 in $cluster2//p
	 where deep-equal($element1 , $element2)
	 return $element1)
return not(empty($commonElements))
};

let $c1 := (<c><p name="ola"/><p/></c>)
let $c2 := (<c><p name="ola" /></c>)
return local:isSimiliarClusters($c1, $c2)

(:local:transitive-closure((<e>a1</e>, <e>a2</e>, <e>b1</e>, <e>c1</e>, <e>a3</e>, <e>b2</e>, <e>c2</e>, <e>a4</e>), 1);:)
