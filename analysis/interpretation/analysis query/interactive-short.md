# Definition
weak {shape} has some unique property of the shape
strong {shape} has a class linked to the shape or has all the property of the shape

Or the shape tell us that the object must be a specific shape and we have a weak shape aligment.

# 1st variation
```
# Profile of a person
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
    ?firstName
    ?lastName
    ?birthday
    ?locationIP
    ?browserUsed
    ?cityId
    ?gender
    ?creationDate
WHERE
{
    ?person a snvoc:Person .
    ?person snvoc:id ?personId .
    ?person snvoc:firstName ?firstName .
    ?person snvoc:lastName ?lastName .
    ?person snvoc:gender ?gender .
    ?person snvoc:birthday ?birthday .
    ?person snvoc:creationDate ?creationDate .
    ?person snvoc:locationIP ?locationIP .
    ?person snvoc:isLocatedIn ?city .
    ?city snvoc:id ?cityId .
    ?person snvoc:browserUsed ?browserUsed .
}
```
## Object
- `?person` we know it is a `Profile` because the class `snvoc:Person` and because of `snvoc:gender` at least.
- `?city`
## Analysis
We can know that `?person` is in the pod by the shape Index with the determinant factor that
the type is `snvoc:Person`.

For the `?city` we cannot know if it is in the pod or somewhere.
But giving the shape we can know the cardinality.

We can make the hypothesis that if the cardinality is finite we only need one document to get the information and use `cMatch`,
we can validate the hypothesis by determining if the dereference document is in a structure environement or not.
If it is then we use all criteria if it is not than we continue with `cMatch`.
If we know that the object is bounded by the index than no hypothesis is need and we don't have to use other criteria.

## Conclusion
- `?person` is a strong `Profile`
- `?city` is inconclusive


We could use `cMatch` + `cShapeIndex`, if the `?city` is in the open web and has a finite
cardinality


# 2nd variation

```
# Recent messages of a person
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
    ?messageId
    ?messageContent
    ?messageCreationDate
    ?originalPostId
    ?originalPostAuthorId
    ?originalPostAuthorFirstName
    ?originalPostAuthorLastName
WHERE {
    ?person a snvoc:Person .
    ?person snvoc:id ?personId .
    ?message snvoc:hasCreator ?person .
    ?message snvoc:content|snvoc:imageFile ?messageContent .
    ?message snvoc:creationDate ?messageCreationDate .
    ?message snvoc:id ?messageId .
    OPTIONAL {
        ?message snvoc:replyOf* ?originalPostInner .
        ?originalPostInner a snvoc:Post .
    } .
    BIND( COALESCE(?originalPostInner, ?message) AS ?originalPost ) .
    ?originalPost snvoc:id ?originalPostId .
    ?originalPost snvoc:hasCreator ?creator .
    ?creator snvoc:firstName ?originalPostAuthorFirstName .
    ?creator snvoc:lastName ?originalPostAuthorLastName .
    ?creator snvoc:id ?originalPostAuthorId .
}
LIMIT 10
```
## Object
- `?person` we know it is a `Profile` because the class `snvoc:Person`
- `?message` it can be either a a `Post` or a `Comment`, because `snvoc:content` and `snvoc:imageFile` which discriminate `Person`. But we cannot assume the exclusion of all the other information in the pod because we have a weak aligment with the `Comment`.
- `?originalPostInner` is a `Post` because of the class `snvoc:Post` and `snvoc:replyOf`
- `?originalPost` can be either a `Post` or a weak `Comment`
- `?creator` can be a weak `Profile` because of the `snvoc:firstName` at least

## Analysis

The `?originalPost`, `?creator` and `?message` are not strongly bound to shape, so since shape index only provide don't force exclusivity of properties but of set of properties or of class if it is defined than we are force to travel the whole pod.

## Conclusion

- `?person` is a `Profile`
- `?message` is a `Post` or a weak `Comment`

We have to use the whole solid traversal reachability

# 3th variation

```
# Friends of a person
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
    ?firstName
    ?lastName
    ?friendshipCreationDate
WHERE
{
    ?rootPerson a snvoc:Person .
    ?rootPerson snvoc:id ?rootId .
    {
        ?rootPerson snvoc:knows ?knows .
        ?knows snvoc:hasPerson ?person .
    } UNION {
        ?person snvoc:knows ?knows .
        ?knows snvoc:hasPerson ?rootPerson .
    }
    ?knows snvoc:creationDate ?friendshipCreationDate .
    ?person snvoc:firstName ?firstName .
    ?person snvoc:lastName ?lastName .
    ?person snvoc:id ?personId .
}
```
# 4th variation

```
# Content of a message
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
    ?messageCreationDate
    ?messageContent
WHERE
{
    ?message snvoc:id ?messageId .
    ?message snvoc:creationDate ?messageCreationDate .
    ?message snvoc:content|snvoc:imageFile ?messageContent .
}
```

# 5th variation

```
# Creator of a message
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
    ?firstName
    ?lastName
WHERE
{
    ?message snvoc:id ?messageId .
    ?message snvoc:hasCreator ?creator .
    ?creator snvoc:id ?personId .
    ?creator snvoc:firstName ?firstName .
    ?creator snvoc:lastName ?lastName .
}
```

# 6th variation

```
# Forum of a message
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
    ?forumId
    ?forumTitle
    ?moderatorId
    ?moderatorFirstName
    ?moderatorLastName
WHERE {
    ?message snvoc:id ?messageId .
    OPTIONAL {
        ?message snvoc:replyOf* ?originalPostInner .
        ?originalPostInner a snvoc:Post .
    } .
    BIND( COALESCE(?originalPostInner, ?message) AS ?originalPost ) .
    ?forum snvoc:containerOf ?originalPost .
    ?forum snvoc:id ?forumId .
    ?forum snvoc:title ?forumTitle .
    ?forum snvoc:hasModerator ?moderator .
    ?moderator snvoc:id ?moderatorId .
    ?moderator snvoc:firstName ?moderatorFirstName .
    ?moderator snvoc:lastName ?moderatorLastName .
}
```

# 7th variation
```
# Replies of a message
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
    ?commentId
    ?commentContent
    ?commentCreationDate
    ?replyAuthorId
    ?replyAuthorFirstName
    ?replyAuthorLastName
    ?replyAuthorKnowsOriginalMessageAuthor
WHERE
{
    ?message snvoc:id ?messageId .
    ?message snvoc:hasCreator ?messageCreator .
    ?messageCreator snvoc:id ?messageCreatorId .
    ?comment snvoc:replyOf ?message .
    ?comment a snvoc:Comment .
    ?comment snvoc:id ?commentId .
    ?comment snvoc:content ?commentContent .
    ?comment snvoc:creationDate ?commentCreationDate .
    ?comment snvoc:hasCreator ?replyAuthor .
    ?replyAuthor snvoc:id ?replyAuthorId .
    ?replyAuthor snvoc:firstName ?replyAuthorFirstName .
    ?replyAuthor snvoc:lastName ?replyAuthorLastName .
    OPTIONAL {
        ?messageCreator ((snvoc:knows/snvoc:hasPerson)|^(snvoc:knows/snvoc:hasPerson)) ?replyAuthor .
        BIND( "true"^^xsd:boolean AS ?replyAuthorKnowsOriginalMessageAuthorInner ) .
    }
    BIND( COALESCE(?replyAuthorKnowsOriginalMessageAuthorInner, "false"^^xsd:boolean) AS ?replyAuthorKnowsOriginalMessageAuthor ) .
}
```
