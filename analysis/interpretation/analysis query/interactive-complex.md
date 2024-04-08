
# 1st variation
```
# Transitive friends with certain name
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?friendId)
    (?last AS ?friendLastName)
    (MIN(?dist) AS ?distanceFromPerson)
    (?bday AS ?friendBirthday)
    (?since AS ?friendCreationDate)
    (?gen AS ?friendGender)
    (?browser AS ?friendBrowserUsed)
    (?locationIP AS ?friendLocationIp)
    (?emails AS ?friendEmails)
    (?languages AS ?friendLanguages)
    (?based AS ?friendCityName)
    (?studies AS ?friendUniversities)
    (?jobs AS ?friendCompanies)
{
    {
        SELECT
            ?fr
            ?emails
            ?dist
            (GROUP_CONCAT(?language;separator=", ") AS ?languages)
        WHERE
        {
            {
                SELECT
                    ?fr
                    ?dist
                    (GROUP_CONCAT(?email;separator=", ") AS ?emails)
                WHERE
                {
                    {
                        SELECT
                            ?fr
                            (MIN(?distInner) AS ?dist)
                        WHERE
                        {
                            ?rootPerson a snvoc:Person .
                            ?rootPerson snvoc:id ?rootId .
                            ?rootPerson snvoc:id ?rootId .
                            ?fr a snvoc:Person .
                            {
                                ?rootPerson (snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson) ?fr .
                                BIND( 1 AS ?distOneInner )
                            } UNION {
                                ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
                                BIND( 2 AS ?distTwoInner )
                            } UNION {
                                ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
                            }
                            ?fr snvoc:id ?frId .
                            FILTER(?frId != ?rootId) .
                            ?fr snvoc:firstName $firstName .
                            BIND( IF(COALESCE(?distOneInner, 4) < 4, 1, IF(COALESCE(?distTwoInner, 4) < 4, 2, 3)) AS ?distInner)
                        }
                        GROUP BY ?fr
                    }
                    ?fr snvoc:email ?email .
                }
                GROUP BY ?fr ?dist
            }
            ?fr snvoc:speaks ?language
        }
        GROUP BY ?fr ?emails ?dist
    }
    ?fr snvoc:id ?frId .
    ?fr snvoc:lastName ?last .
    ?fr snvoc:birthday ?bday .
    ?fr snvoc:isLocatedIn ?basedURI .
    ?basedURI foaf:name ?based .
    ?fr snvoc:creationDate ?since .
    ?fr snvoc:gender ?gen .
    ?fr snvoc:locationIP ?locationIP .
    ?fr snvoc:browserUsed ?browser .
    OPTIONAL {
        {
            SELECT
                (?frInner AS ?frInnerUni)
                (GROUP_CONCAT(CONCAT(?uniName, " ", xsd:string(?classYear), " ", ?uniCountry);separator=", ") AS ?studies)
            {
                SELECT DISTINCT
                    ?frInner
                    ?uniName
                    ?classYear
                    ?uniCountry
                {
                    ?frInner a snvoc:Person .
                    ?frInner snvoc:studyAt ?study .
                    ?study snvoc:hasOrganisation ?uni .
                    ?uni foaf:name ?uniName .
                    ?study snvoc:classYear ?classYear .
                    ?uni snvoc:isLocatedIn/foaf:name ?uniCountry .
                }
            }
            GROUP BY ?frInner
        } .
        ?frInnerUni snvoc:id ?frInnerUniId .
        FILTER( ?frId = ?frInnerUniId)
    } .
    OPTIONAL {
        {
            SELECT
                (?frInner AS ?frInnerComp)
                (GROUP_CONCAT(CONCAT(?companyName, " ", xsd:string(?workFrom), " ", ?companyCountry);separator=", ") AS ?jobs)
            {
                SELECT DISTINCT
                    ?frInner
                    ?companyName
                    ?workFrom
                    ?companyCountry
                {
                    ?frInner a snvoc:Person .
                    ?frInner snvoc:workAt ?work .
                    ?work snvoc:hasOrganisation ?company .
                    ?work snvoc:workFrom ?workFrom .
                    ?company snvoc:isLocatedIn/foaf:name ?companyCountry .
                    ?company foaf:name ?companyName
                }
            }
            GROUP BY ?frInner
        } .
        ?frInnerComp snvoc:id ?frInnerCompId .
        FILTER( ?frId = ?frInnerCompId)
    }
}
GROUP BY ?frId ?last ?bday ?since ?gen ?browser ?locationIP ?based ?studies ?jobs ?emails ?languages
ORDER BY ?distanceFromPerson ?last ?frId
LIMIT 20
```

# 2nd variation
```
# Recent messages by your friends
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?first AS ?personFirstName)
    (?last AS ?personLastName)
    ?messageId
    (?content AS ?messageContent)
    (?creationDate AS ?messageCreationDate)
WHERE
{
    VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
    {
        SELECT DISTINCT
            ?fr
        WHERE {
            ?rootPerson a snvoc:Person .
            ?fr a snvoc:Person .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr
        }
    }
    ?message snvoc:hasCreator ?fr .
    ?message a ?type
    {
        {
            ?message snvoc:content ?content
        } UNION {
            ?message snvoc:imageFile ?content
        }
    } .
    ?message snvoc:creationDate ?creationDate .
    ?message snvoc:id ?messageId .
    FILTER (?creationDate <= ?maxDate) .
    ?fr snvoc:firstName ?first .
    ?fr snvoc:lastName ?last .
    ?fr snvoc:id ?frId .
}
ORDER BY DESC(?creationDate) ?message
LIMIT 20
```

# 3th variation
```
# Friends and friends of friends that have been to given countries
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?firstName AS ?personFirstName)
    (?lastName AS ?personLastName)
    ?xCount
    ?yCount
    (?xCount + ?yCount AS ?count)
WHERE
{
    {
        SELECT DISTINCT
            ?fr
            ?frId
        WHERE
        {
            ?rootPerson a snvoc:Person .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))?/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
            ?fr snvoc:id ?frId .
            ?fr snvoc:isLocatedIn/snvoc:isPartOf ?country .
            ?country a dbpedia-owl:Country .
            ?country foaf:name ?countryName .
            FILTER(?fr != ?rootPerson && ?countryName != ?countryXName && ?countryName != ?countryYName)
        }
    }
    {
        SELECT
            (?frId AS ?frIdX)
            (COUNT(*) AS ?xCount)
        WHERE
        {
            BIND( ?startDate AS ?date1 ) .
            BIND( ?date1 + STRDT(CONCAT("P", ?durationDays, "D"), xsd:duration) AS ?date2 ) .
            VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
            ?message a ?type .
            ?message snvoc:creationDate ?creationDate .
            FILTER( ?creationDate >= ?date1 && ?creationDate < ?date2 ) .
            ?message snvoc:hasCreator ?fr .
            ?fr a snvoc:Person .
            ?fr snvoc:id ?frId .
            ?message snvoc:isLocatedIn ?country .
            ?country a dbpedia-owl:Country .
            ?country foaf:name ?countryXName .
        }
        GROUP BY ?frId
    } .
    FILTER( ?frId = ?frIdX ) .
    {
        SELECT
            (?frId AS ?frIdY)
            (COUNT(*) AS ?yCount)
        WHERE
        {
            BIND( ?startDate AS ?date1 ) .
            BIND( ?date1 + STRDT(CONCAT("P", ?durationDays, "D"), xsd:duration) AS ?date2 ) .
            VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
            ?message a ?type .
            ?message snvoc:creationDate ?creationDate .
            FILTER( ?creationDate >= ?date1 && ?creationDate < ?date2 ) .
            ?message snvoc:hasCreator ?fr .
            ?fr a snvoc:Person .
            ?fr snvoc:id ?frId .
            ?message snvoc:isLocatedIn ?country .
            ?country a dbpedia-owl:Country .
            ?country foaf:name ?countryYName .
        }
        GROUP BY ?frId
    } .
    FILTER( ?frId = ?frIdY )
    ?fr snvoc:firstName ?firstName .
    ?fr snvoc:lastName ?lastName
}
ORDER BY DESC(?sum) ?fr
LIMIT 20
```
# 4th variation
```
# New topics
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    ?tagName
    (COUNT(*) AS ?postCount)
WHERE {
    BIND( ?startDate + STRDT(CONCAT("P", ?durationDays, "D"), xsd:duration) AS ?endDate ) .
    ?rootPerson a snvoc:Person .
    ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
    ?post a snvoc:Post .
    ?post snvoc:hasCreator ?fr .
    ?post snvoc:hasTag ?tag .
    ?tag foaf:name ?tagName .
    ?post snvoc:creationDate ?creationDate .
    FILTER (?creationDate >= ?startDate && ?creationDate <= ?endDate ) .
    FILTER NOT EXISTS {
        ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr2 .
        ?post2 snvoc:hasCreator ?fr2 .
        ?post2 a snvoc:Post .
        ?post2 snvoc:hasTag ?tag .
        ?post2 snvoc:creationDate ?creationDate2 .
        FILTER (?creationDate2 < ?startDate)
    }
}
GROUP BY ?tagName
ORDER BY DESC(?postCount) ?tagName
LIMIT 10
```
## Analysis
- `?rootPerson`
- `?post`
- `?tag`
- `?post2`
## Conclusion

# 5th variation
```
# New groups
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?title AS ?forumTitle)
    (SUM(?hasPost) AS ?postCount)
WHERE
{
    {
        SELECT DISTINCT
            ?fr
            ?forum
        WHERE
        {
            {
                SELECT DISTINCT
                    ?fr
                    ?frId
                WHERE
                {
                    ?rootPerson a snvoc:Person .
                    ?rootPerson snvoc:id ?rootId .
                    ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))?/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
                    ?fr snvoc:id ?frId .
                    FILTER(?frId != ?rootId)
                }
            } .
            ?forum a snvoc:Forum .
            ?forum snvoc:hasMember ?mem .
            ?mem snvoc:hasPerson ?fr .
            ?mem snvoc:joinDate ?date .
            FILTER( ?date >= ?minDate ) .
        }
    }
    OPTIONAL {
        ?post a snvoc:Post .
        ?post snvoc:hasCreator ?fr .
        ?forum snvoc:containerOf ?post .
        BIND( 1 AS ?hasPostInner )
    } .
    ?forum snvoc:title ?title .
    ?forum snvoc:id ?forumId .
    BIND( COALESCE(?hasPostInner, 0) AS ?hasPost )
}
GROUP BY ?title ?forumId
ORDER BY DESC(?postCount) ?forumId
LIMIT 20
```
## Analysis
- `?rootPerson`: A **Strong** `Person`
- `?fr`: `Unknown` unless it is bind by `?rootPerson`, `?post`
- `?forum`: A **Strong NON existing** `Forum`
- `?mem`:  `Nothing`
- `post`: A **Strong** `Post`

## Conclusion
We have to traverse the whole pod unless `?mem` is outside of the pod, `fr` is bind by `?rootPerson` and/or `?post` and `?forum` is outside the pod.

# 6th variation
```
# Tag co-occurrence
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?tag2Name AS ?tagName)
    (COUNT(?post) AS ?postCount)
WHERE
{
    BIND($tagName AS ?tagNameParam)
    {
        SELECT DISTINCT
            ?fr
            ?frId
        WHERE
        {
            ?rootPerson a snvoc:Person .
            ?rootPerson snvoc:id ?rootId .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))?/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
            ?fr snvoc:id ?frId .
            FILTER(?frId != ?rootId)
        }
    } .
    ?post a snvoc:Post .
    ?post snvoc:hasCreator ?fr .
    ?post snvoc:hasTag ?tag1 .
    ?tag1 foaf:name ?tagNameParam .
    ?post snvoc:hasTag ?tag2 .
    ?tag2 foaf:name ?tag2Name .
    FILTER (?tag2Name != ?tagNameParam) .
}
GROUP BY ?tag2Name
ORDER BY DESC(?postCount) ?tag2Name
LIMIT 10
```
## Analysis
- `?rootPerson`: A **Strong** `Person`
- `?fr`: `Unknown` unless it is bind by `?rootPerson`
- `?post`: A **Strong** `Post`
- `?tag1`: `Nothing` unless it is bind by `?post`
- `?tag2`: `Nothing` unless it is bind by `?post`
## Conclusion
We have to traverse the whole pod unless `fr` is bind by `?rootPerson` and `?tag1` and `?tag2` is outside of the pod or bind by `?post`.

# 7th variation
```
# Recent likers
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    ?personId
    (?firstName AS ?personFirstName)
    (?lastName AS ?personLastName)
    ?likeCreationDate
    (?minMessageId AS ?messageId)
    (?content AS ?messageContent)
    (?latency AS ?minutesLatency)
    ?isNew
WHERE
{
    {
        SELECT
            ?person
            (MIN(?messageId) AS ?minMessageId)
        WHERE
        {
            {
                SELECT
                    ?personId
                    (MAX(?likeDate) AS ?mostRecentLikeDate)
                WHERE
                {
                    {
                        SELECT DISTINCT
                            ?message
                        WHERE
                        {
                            VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
                            ?rootPerson a snvoc:Person .
                            ?message snvoc:hasCreator ?rootPerson .
                            ?message a ?type
                        }
                    } .
                    ?person a snvoc:Person .
                    ?person snvoc:likes ?like .
                    ?person snvoc:id ?personId .
                    ?like snvoc:hasPost|snvoc:hasComment ?message .
                    ?like snvoc:creationDate ?likeDate .
                }
                GROUP BY ?personId
                ORDER BY DESC(?mostRecentLikeDate) ?personId
                LIMIT 20
            }
            VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
            ?rootPerson a snvoc:Person .
            ?message snvoc:hasCreator ?rootPerson .
            ?message a ?type .
            ?message snvoc:id ?messageId .
            ?person a snvoc:Person .
            ?person snvoc:id ?personId .
            ?person snvoc:likes ?like .
            ?like snvoc:hasPost|snvoc:hasComment ?message .
            ?like snvoc:creationDate ?mostRecentLikeDate .
        }
        GROUP BY ?person
    } .
    ?person snvoc:id ?personId .
    ?person snvoc:firstName ?firstName .
    ?person snvoc:lastName ?lastName .
    ?person snvoc:likes ?like .
    ?like snvoc:hasPost|snvoc:hasComment ?message .
    ?message snvoc:id ?minMessageId .
    ?like snvoc:creationDate ?likeCreationDate .
    ?message snvoc:creationDate ?messageCreationDate .
    ?message snvoc:content|snvoc:imageFile ?content .
    BIND( ?likeCreationDate - ?messageCreationDate AS ?latencyInDuration )
    BIND( (DAY(?latencyInDuration) * 24 + HOURS(?latencyInDuration)) * 60 + MINUTES(?latencyInDuration) AS ?latency )
    ?rootPerson a snvoc:Person .
    BIND( NOT EXISTS { ?rootPerson (snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson) ?person } AS ?isNew )
}
ORDER BY DESC(?likeCreationDate) ?personId
```
## Analysis
- `?rootPerson`: A **Strong** `Person`
- `?like`: Unknown unless `?person` bind the type
- `?message`: A **Strong** `Comment` or `Post`
- `?person`: A **Strong** `Person`
## Conclusion
We have to traverse the pod unless `?person` bind the type of `?like`.

# 8th variation
```
# Recent replies
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    ?personId
    ?personFirstName
    ?personLastName
    ?commentCreationDate
    ?commentId
    ?commentContent
WHERE
{
    VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
    ?rootPerson a snvoc:Person .
    ?message snvoc:hasCreator ?rootPerson .
    ?message a ?type .
    ?comment a snvoc:Comment .
    ?comment snvoc:replyOf ?message .
    ?comment snvoc:creationDate ?commentCreationDate .
    ?comment snvoc:id ?commentId .
    ?comment snvoc:content ?commentContent .
    ?comment snvoc:hasCreator ?person .
    ?person snvoc:id ?personId .
    ?person snvoc:firstName ?personFirstName .
    ?person snvoc:lastName ?personLastName
}
ORDER BY DESC(?commentCreationDate) ?commentId
LIMIT 20
```
## Analysis
- `?rootPerson`: A **Strong** `Person`
- `?message`: A **Strong** `Comment` or `Post`
- `?comment`: A **Strong** `Comment`
- `?person`: A **Weak** `Person` with the alignment or a strong something if `?comment` bind it.

## Conclusion

We have to traverse the pod unless `?person` is bind by `?comment`

# 9th variation
```
# Recent messages by friends or friends of friends
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?first AS ?personFirstName)
    (?last AS ?personLastName)
    ?messageId
    (?content AS ?messageContent)
    (?creationDate AS ?messageCreationDate)
WHERE {
    VALUES (?type) {(snvoc:Comment) (snvoc:Post)}
    {
        SELECT DISTINCT
            ?fr
            ?frId
        WHERE
        {
            ?rootPerson a snvoc:Person .
            ?rootPerson snvoc:id ?rootId .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))?/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
            ?fr snvoc:id ?frId .
            FILTER(?frId != ?rootId)
        }
    } .
    ?message snvoc:hasCreator ?fr .
    ?message a ?type .
    ?message snvoc:creationDate ?creationDate .
    FILTER(?creationDate < ?maxDate) .
    ?message snvoc:content|snvoc:imageFile ?content .
    ?message snvoc:id ?messageId .
    ?fr snvoc:firstName ?first .
    ?fr snvoc:lastName ?last .
    ?fr snvoc:id ?frId
}
ORDER BY DESC(?creationDate) ?post
LIMIT 20
```
## Analysis
- `?rootPerson`: A **Strong** `Person`
- `?fr`: A **Weak** `Person` with the alignment unless `?rootPerson` bind it.
- `?message`: A **Strong** `Comment` or `Post`
## Conclusion

We have to traverse the pod unless `?rootPerson` bind `type`

# 10th variation
```
# Friend recommendation
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?first AS ?personFirstName)
    (?last AS ?personLastName)
    (?commonScore AS ?commonInterestScore)
    (?gender AS ?personGender)
    (?locationName AS ?personCityName)
WHERE
{
    BIND(IF(?month = 12, 1, ?month + 1) AS ?nextMonth)
    {
        SELECT DISTINCT
            ?fr
            ?frId
        WHERE
        {
            ?rootPerson a snvoc:Person .
            ?rootPerson snvoc:id ?rootId .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
            ?fr snvoc:id ?frId .
            FILTER(?frId != ?rootId) .
            FILTER NOT EXISTS {
                ?rootPerson (snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson) ?fr .
            }
        }
    } .
    ?fr snvoc:firstName ?first .
    ?fr snvoc:lastName ?last .
    ?fr snvoc:gender ?gender .
    ?fr snvoc:birthday ?bday .
    ?fr snvoc:isLocatedIn ?based .
    ?based foaf:name ?locationName .
    FILTER ( (MONTH(?bday) = ?month && DAY(?bday) >= 21) || (MONTH(?bday) = (?nextMonth) && DAY(?bday) < 22) ) .
    OPTIONAL {
        {
            SELECT
                ?frCommonInner
                ?frCommonInnerId
                (COUNT(?post) AS ?commonScoreInner)
            WHERE
            {
                SELECT DISTINCT
                    ?frCommonInner
                    ?frCommonInnerId
                    ?post
                WHERE {
                    ?rootPerson a snvoc:Person .
                    ?post a snvoc:Post .
                    ?post snvoc:hasCreator ?frCommonInner .
                    ?frCommonInner snvoc:id ?frCommonInnerId .
                    ?post snvoc:hasTag ?tag .
                    ?rootPerson snvoc:hasInterest ?tag
                }
            }
            GROUP BY ?frCommonInner ?frCommonInnerId
        }
        FILTER(?frCommonInnerId = ?frId)
    } .
    OPTIONAL {
        {
            SELECT DISTINCT
                ?frTotalInner
                ?frTotalInnerId
            (COUNT(?post) AS ?totalPostCountInner)
            WHERE {
                ?post a snvoc:Post .
                ?post snvoc:hasCreator ?frTotalInner .
                ?frTotalInner a snvoc:Person .
                ?frTotalInner snvoc:id ?frTotalInnerId .
            }
            GROUP BY ?frTotalInner ?frTotalInnerId
        }
        FILTER(?frTotalInnerId = ?frId)
    }
    BIND( 2 * COALESCE(?commonScoreInner, 0) - COALESCE(?totalPostCountInner, 0) AS ?commonScore )
}
ORDER BY DESC(?commonScore) ?frId
LIMIT 10
```

## Analysis
- `?rootPerson`: **Strong** `Person`
- `?post`:  **Strong** `Post`
- `?frCommonInner`: a **Weak** `Post`, `Comment`, `Person` unless it is given by a constraint by `Post` in `?post`
- `?frTotalInner`: **Strong** Person

## Conclusion
We have to traverse the Pod unless `?post` bind a compatible type to `frCommonInner`

# 11th variation
```
# Job referral
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?first AS ?personFirstName)
    (?last AS ?personLastName)
    (?orgName AS ?organizationName)
    (?startYear AS ?organizationWorkFromYear)
WHERE {
    {
        SELECT DISTINCT
            ?fr
            ?frId
        WHERE
        {
            ?rootPerson a snvoc:Person .
            ?rootPerson snvoc:id ?rootId .
            ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson))?/((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
            ?fr snvoc:id ?frId .
            FILTER(?frId != ?rootId)
        }
    } .
    ?fr snvoc:workAt ?work .
    ?work snvoc:workFrom ?startYear .
    FILTER (?startYear < ?workFromYear) .
    ?work snvoc:hasOrganisation ?org .
    ?org foaf:name ?orgName .
    ?org snvoc:isLocatedIn ?country.
    ?country foaf:name ?countryName .
    ?fr snvoc:firstName ?first .
    ?fr snvoc:lastName ?last .
}
ORDER BY ?startYear ?frId DESC(?orgName)
LIMIT 10
```
## Analysis
- `?rootPerson`: **Strong** `Person`
- `?fr`: **Weak** `Person` using the intersection algoritm
- `?work`: `Unknown`
- `?org`: **Weak** `Person` (unless `?work` was outside of the env)
- `?country`: `Unknown` (unless `?work` was outside of the env implied by `?org`)

## Conclusion
We have to traverse the pod

# 12th variation
```
# Expert search
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX sn: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/data/>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
PREFIX sntag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dbpedia: <http://localhost:3000/dbpedia.org/resource/>
PREFIX dbpedia-owl: <http://localhost:3000/dbpedia.org/ontology/>

SELECT
    (?frId AS ?personId)
    (?first AS ?personFirstName)
    (?last AS ?personLastName)
    (GROUP_CONCAT(DISTINCT ?tagName;separator=', ') AS ?tagNames)
    (COUNT(DISTINCT ?reply) AS ?replyCount)
WHERE
{
    ?rootPerson a snvoc:Person .
    ?rootPerson ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?fr .
    ?fr snvoc:id ?frId .
    ?fr snvoc:firstName ?first .
    ?fr snvoc:lastName ?last .
    ?reply snvoc:hasCreator ?fr .
    ?reply snvoc:replyOf ?post .
    ?post a snvoc:Post .
    ?post snvoc:hasTag ?tag .
    ?tag foaf:name ?tagName .
    ?tag a ?tagType.
    ?tagType rdfs:subClassOf* ?tagSuperType .
    ?tagSuperType rdfs:label ?tagClassName .
}
GROUP BY ?frId ?first ?last
ORDER BY DESC(?replyCount) ?frId
LIMIT 20
```

## Object
- `?rootPerson`: a **strong** `Person`
- `?fr`: a **weak** `Person`
- `?reply` : a **weak** `Comment`
- `?post` : a **strong** `Post`
- `?tag`: **unknown**
- `?tagType`: **unknown**
- `?tagSuperType`: **unknown**
## Analysis

## Conclusion
The engine must traverse the pod and nothing can be prune.
