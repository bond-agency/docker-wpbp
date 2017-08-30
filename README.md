# docker-wpbp

Docker WordPress boilerplate is opinionated docker-compose template to start WordPress project with Docker.

**NOTICE: This boilerplate has not yet been tested in production.**

## Requirements

You need to have [Docker](https://www.docker.com/) and docker-compose installed. This boilerplate is intended to be used with [nginx-le-proxy](https://github.com/bond-agency/nginx-le-proxy) and you need to bind the wanted port to the nginx container if you don't want to use the proxy.

## Usage

Download the boilerplate as a zip file to use it as base for a new project.

Add next line to your `.bash_profile` (or `.zshrc` etc.) file.
```bash
# Export your user id
export USER_ID=$(id -u)
```
This ensures that docker-compose has always your user ID available as environment variable and it can be mapped for the containers. This needs to be done only once. Remember to source the file before continuing: `source ~/.bash_profile`.

Next you need to define all of the remaining variables in all relevant compose files. There is compose files for three different environments: `development`, `staging` and `production`.

```yml
...
- VIRTUAL_HOST=wpdocker.dev
...
- MYSQL_ROOT_PASSWORD=example
...
- WPTB_ENV=development # This can be either development, staging or production
- WORDPRESS_DB_PASSWORD=example # This needs to be same as MYSQL_ROOT_PASSWORD
```
These are the minimum values you need to change. If you are configuring the staging or production environment compose files you also need to configure the Let's Encrypt values to get SSL certificates:
```yml
- LETSENCRYPT_HOST=example.com # Use same value as in VIRTUAL_HOST. This can also be a list like example.com,www.example.com
- LETSENCRYPT_EMAIL=mail@example.com
```

If you are working on development environment, make sure that you have updated your `/etc/hosts` file with the same value as you have in the `VIRTUAL_HOST` variable:

```
127.0.0.1   wpdocker.dev
```

Start the [nginx-le-proxy](https://github.com/bond-agency/nginx-le-proxy).

Now you can start the project with command:
```bash
docker-compose -f docker-compose.development.yml up -d
```

Now you can follow the logs of the composed containers with:
```
docker-compose -f docker-compose.development.yml logs -f
```

To rebuild the containers every time you can add `--build` flag to the `up`-command.

The `wordpress/wp-content` folder is mounted from host machine so this the place where to put your own code.

## Contributing

You can open an issue if you have found a bug or you have an enhancement suggestion.