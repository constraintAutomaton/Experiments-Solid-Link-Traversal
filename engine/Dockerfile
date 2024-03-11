FROM node:18

# Install location
ENV dir /var/www/@comunica/query-sparql-link-traversal-solid

# Copy the engine files (generated from package.json!files)
COPY config ${dir}/config/
COPY lib/*.js ${dir}/lib/
COPY bin/*.js ${dir}/bin/
COPY engine-default.js package.json install.sh ${dir}/
COPY comunica-feature-link-traversal ${dir}/comunica-feature-link-traversal/

# Set the npm registry
ARG NPM_REGISTRY=https://registry.npmjs.org/
RUN npm config set @comunica:registry $NPM_REGISTRY

# Install the node module
RUN cd ${dir} &&  ./install.sh

# Run base binary (generated from package.json!bin)
WORKDIR ${dir}
ENTRYPOINT ["node", "./bin/query.js"]

# Default command
CMD ["--help"]
