# first variation
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
- `?person` and we know the class `snvoc:Person`
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

We could use `cMatch` + `cShapeIndex`


# second variation

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

