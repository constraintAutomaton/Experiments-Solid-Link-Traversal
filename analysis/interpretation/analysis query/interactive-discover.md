# 1st variation

```
# All posts of a person
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
    ?messageCreationDate
    ?messageContent
WHERE
{
    ?message snvoc:hasCreator ?person;
        rdf:type snvoc:Post;
        snvoc:content ?messageContent;
        snvoc:creationDate ?messageCreationDate;
        snvoc:id ?messageId.
}
```

## Object
- `?message` is  **strong** `Post`

## Analysis
We don't have to visit the pod because we know everything going to be in the `Post` resource

## Conclusion
We don't have to visit the pod we can simply `cMatch` and `CShapeIndex`

# 2nd variation

```
# All messages of a person
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
    ?messageCreationDate
    ?messageContent
WHERE
{
    ?message snvoc:hasCreator ?person;
        snvoc:content ?messageContent;
        snvoc:creationDate ?messageCreationDate;
        snvoc:id ?messageId.
    { ?message rdf:type snvoc:Post } UNION { ?message rdf:type snvoc:Comment }
}
```
## Object
- `?message` - a **strong** `Post` or `Comment`
## Analysis
We have know the exact location of the `?message` so we don't need to visit the pod
## Conclusion
We don't need to visite the pod

# 3th variation
```
# Top tags in messages from a person
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
    (COUNT(?message) as ?messages)
WHERE
{
    ?message snvoc:hasCreator ?person;
        snvoc:hasTag ?tag.
    ?tag foaf:name ?tagName.
}
GROUP BY ?tagName
ORDER BY DESC(?messages)
```
## Object
- `?message` - it is a **weak** `Post` or `Comment`
- `?tag` -  we cannot know the type
## Analysis
We for message prune the `Profile`, but we have to visit it for the `?tag`
## Conlusion
We have to traverse the whole pod exept for the `Profile` unless `?tag` is
not in a pod.

# 4th variation
```
# Top locations in comments from a person
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
    ?locationName
    (COUNT(?message) as ?messages)
WHERE
{
    ?message snvoc:hasCreator ?person;
        rdf:type snvoc:Comment;
        snvoc:isLocatedIn ?location.
    ?location foaf:name ?locationName.
}
GROUP BY ?locationName
ORDER BY DESC(?messages)
```
## Object
- `?message` - It is a **strong** `Comment`
- `?location`- we cannot know
## Analysis
We have to traverse the whole pod apart from `Profile` unless `location` is outside a pod.
## Conclusion
We have to traverse the whole pod apart from `Profile` unless `location` is outside a pod then
we could use `cMatch` and `CShapeIndex`

# 5th variation

```
# All IPs a person has messaged from
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
DISTINCT
    ?locationIp
WHERE
{
    ?message snvoc:hasCreator ?person;
        snvoc:locationIP ?locationIp.
}
```
## Object
- `?message` we cannot know it's class
## Analysis
We have to traverse the whole pod
## Conclusion
We are force to traverse the whole pod

# 6th variation

```
# All fora a person messaged on
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
DISTINCT
    ?forumId
    ?forumTitle
WHERE
{
    ?message snvoc:hasCreator ?person.
    ?forum snvoc:containerOf ?message;
            snvoc:id ?forumId;
            snvoc:title ?forumTitle.
}
```
## Object
- `?message` - We cannot know what it is
- `?forum` - We cannot know what is is
## Analysis
We have no special information
## Conclusion
We have to traverse the whole pod

# 7th variation
```
# All moderators in fora a person messaged on
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
DISTINCT
    ?firstName
    ?lastName
WHERE
{
    ?message snvoc:hasCreator ?person.
    ?forum snvoc:containerOf ?message;
        snvoc:hasModerator ?moderator.
    ?moderator snvoc:firstName ?firstName .
    ?moderator snvoc:lastName ?lastName .
}
```
## Object
- `?message` - we canot know what it is
- `?forum` - we cannot know what it is
- `?moderator` - it is a weak `Person`

## Analysis

## Conclusion
We have to traverse the whole pod

# 8th variation
```
# Other messages created by people that a person likes messages from
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
DISTINCT
    ?creator
    ?messageContent
WHERE
{
    ?person snvoc:likes [ snvoc:hasPost|snvoc:hasComment ?message ].
    ?message snvoc:hasCreator ?creator.
    ?otherMessage snvoc:hasCreator ?creator;
        snvoc:content ?messageContent.
} LIMIT 10
```
## Object
- `?person`: is a weak `Person`
- BLANK NODE: we cannot know
- `?message` : We cannot know
- `?otherMessage` : is a **weak** `Comment`
## Analysis

## Conclusion

We have to traverse the pod
