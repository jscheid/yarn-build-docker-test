# yarn workspaces + yarn.build + Docker caching

This is a (failing) test case for building a monorepo using [Yarn 2
workspaces](https://yarnpkg.com/features/workspaces) with
[yarn.build](https://yarn.build/) in Docker, taking advantage of the
[Docker build
cache](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache).

This monorepo contains three packages: `packageA`, `packageB`, and
`packageC`. `packageA` has no dependencies. `packageB` depends on
`packageA`, and `packageC` depends on `packageB`.

The Dockerfile first adds all files that are needed for Yarn to
install dependencies, and then runs `yarn` to do so.  It then first
builds `packageA` which has no dependencies. Then it builds
`packageB`, which depends on `packageA`, which has already been
built. Finally, it builds `packageC`.

To execute the Dockerfile run the following command:

```
docker build .
```

The build fails because it tries to build `packageB` when its files
(other than `package.json`) have not been copied yet.
