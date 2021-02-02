FROM node:14

WORKDIR /usr/src

# Copy all files needed for installing dependencies
ADD package.json yarn.lock .yarnrc.yml ./
ADD .yarn ./.yarn/
ADD packages/packageA/package.json ./packages/packageA/
ADD packages/packageB/package.json ./packages/packageB/
ADD packages/packageC/package.json ./packages/packageC/

# Install dependencies
RUN yarn

# Copy and build packageA
#
# Note: if we'd copy _all_ packages here, this would cause packageA to
# be rebuilt even if only packageB or packageC was changed (because
# the way Docker layers work, the previous build results would be
# discarded when Docker is forced to restart at this layer.
#
ADD packages/packageA/ ./packages/packageA/
RUN yarn build packageA

# Copy and build packageB
ADD packages/packageB/ ./packages/packageB/
RUN yarn build packageB

# Copy and build packageC
ADD packages/packageC/ ./packages/packageC/
RUN yarn build packageC
