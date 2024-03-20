import { QueryEngineFactory } from "@comunica/query-sparql-link-traversal-solid";
import { LoggerPretty } from '@comunica/logger-pretty';

const query = `PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX snvoc: <http://solidbench-server:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
SELECT ?firstName ?lastName ?birthday ?locationIP ?browserUsed ?cityId ?gender ?creationDate WHERE {
  <http://solidbench-server:3000/pods/00000000000000000933/profile/card#me> rdf:type snvoc:Person;
    snvoc:id ?personId;
    snvoc:firstName ?firstName;
    snvoc:lastName ?lastName;
    snvoc:gender ?gender;
    snvoc:birthday ?birthday;
    snvoc:creationDate ?creationDate;
    snvoc:locationIP ?locationIP;
    snvoc:isLocatedIn ?city.
  ?city snvoc:id ?cityId.
  <http://solidbench-server:3000/pods/00000000000000000933/profile/card#me> snvoc:browserUsed ?browserUsed.
}

`;
const configPath = '/home/id357/Documents/PhD/coding/Experiments-Solid-Link-Traversal/config-client/ldp-filtered-type-index.json';
const engine = await new QueryEngineFactory().create({ configPath });

const bindingsStream = await engine.queryBindings(query, {
    lenient: true,
    log: new LoggerPretty({ level: 'trace' }),
});

bindingsStream.on('data', (binding) => {
    //console.log(binding.toString());
});