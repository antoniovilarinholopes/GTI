declare default element namespace "http://www.parlamento.pt";

let $polcodelt3 := (for $pol in //politician
 		    where count(for $speech in //speech
                                where $speech[@politician = $pol/@code]
                                return $speech) < 3
                    return $pol/@code)

for $poltoremove in $polcodelt3
return
(
delete nodes (//speech[@politician = $poltoremove], //politicians/politician[@code = $poltoremove])
)