declare function local:processClusterList($clusters) {
let $processedCluster := 
	(
		for $position in 1 to fn:count($clusters)
		return local:processCluster($clusters, $position)
	)

let $removedElementDuplicates := 
	(
		for $elem in $processedCluster	
		return local:removeDuplicatedElements($elem)
	)

let $removedClusterDuplicates := local:removeDuplicatedClusters($removedElementDuplicates)

return 
	if (deep-equal($clusters, $removedClusterDuplicates))
	then $removedClusterDuplicates
	else local:processClusterList($removedClusterDuplicates)
};


declare function local:removeDuplicatedClusters($clusterList) {
	for $position in 1 to count($clusterList)
	where not(some $nodeInSeq in subsequence($clusterList, $position+1) satisfies local:sequence-node-equal-any-order($nodeInSeq/p,$clusterList[$position]/p))
	return $clusterList[$position]
};

declare function local:sequence-node-equal-any-order($seq1, $seq2) as xs:boolean {
	let $diff1 := (for $elem1 in $seq1
		where not(local:is-node-in-sequence($elem1, $seq2))
		return $elem1)
	let $diff2 := (for $elem2 in $seq2
		where not(local:is-node-in-sequence($elem2, $seq1))
		return $elem2)
	return empty(($diff1, $diff2))
};

declare function local:removeDuplicatedElements($cluster) {
<cluster>
{for $position in 1 to count($cluster/p)
where not(local:is-node-in-sequence($cluster/p[$position], subsequence($cluster/p, $position+1)))
return $cluster/p[$position]}
</cluster>
};

declare function local:is-node-in-sequence($node as node()?, $seq as node()* )  as xs:boolean {
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
};

(: returns a new cluster as a result of joining with the rest of the clusters :)
declare function local:processCluster($clusters, $clusterPosition) {
	let $list := (
		for $position in ((1 to $clusterPosition - 1),($clusterPosition+1 to fn:count($clusters)))
		return		
			if(local:isSimiliarClusters($clusters[$position], $clusters[$clusterPosition]))
			then 
				<cluster>
				{
				(for $politician in $clusters[$position]//p
				return $politician,
				for $politician in $clusters[$clusterPosition]//p
				return $politician)
				}
				</cluster>
			else())
	return
		if(empty($list))
		then $clusters[$clusterPosition]
		else $list

};

(:FIXME ver ///p em conformidade com o 1.1:)
(: a cluster is similiar with another if it has at least one equal element :)
declare function local:isSimiliarClusters($cluster1, $cluster2) {

let $commonElements := 
	(for $element1 in $cluster1//p, $element2 in $cluster2//p
	 where deep-equal($element1 , $element2)
	 return $element1)
return not(empty($commonElements))
};

(:let $c1 := (<c><p name="ola"/><p/></c>)
let $c2 := (<c><p name="ola" /></c>)
return local:isSimiliarClusters($c1, $c2)
local:removeDuplicatedElements(<c><p name="ola"/><p name="ola"/><p name="adeus"/><p name="adeus"/></c>):)

(:local:removeDuplicatedClusters((<c><p name="ola"/><p name="adeus"/></c>,<c><p name="adeus"/><p name="ola"/></c>,<c><a/></c>)):)

local:processClusterList((<cluster><p name="a"/><p name="b"/><p name="c"/></cluster>,<cluster><p name="b"/><p name="c"/></cluster>,<cluster><p name="d"/><p name="e"/></cluster>))

(:local:sequence-node-equal-any-order((<p name="ola"/>),(<p name="adeus"/>,<p name="ola"/>)):)

(:local:removeDuplicatedClusters((<c><p name="ola"/><p name="adeus"/></c>,<c><p name="adeus"/><p name="ola"/></c>,<c><a/></c>)):)
