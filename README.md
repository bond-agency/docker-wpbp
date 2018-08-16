# docker-wpbp

Docker WordPress boilerplate is opinionated docker-compose template to start WordPress project with Docker.

## Requirements

You need to have [Docker](https://www.docker.com/) and docker-compose installed. This boilerplate is intended to be used with [nginx-le-proxy](https://github.com/bond-agency/nginx-le-proxy) and you need to bind the wanted port to the nginx container if you don't want to use the proxy. The `start.sh` also requires `envsubst` to be installed.

## Usage

Download the boilerplate as a zip file to use it as base for a new project.

Add next line to your `.bash_profile` (or `.zshrc` etc.) file.
```bash
# Export your user id
export USER_ID=$(id -u)
```
This ensures that docker-compose has always your user ID available as environment variable and it can be mapped for the containers. This needs to be done only once. Remember to source the file before continuing:

```
source ~/.bash_profile
```

Now you need to define the `.env` file for rest of the variables. You can use the `.env.sample` as sample file and change the values for your purposes. You may also want to rename and duplicate the sample file for all different environments you are using like `.env.development`, `.env.staging` and `.env.production`.

```bash
# Define the used WPTB environment (development/staging/production)
export WPTB_ENV=development

# Select which nginx configuration to use (development/staging/production)
export NGINX_ENV=development

# Select the vhost/domain to use
export VIRTUAL_HOST=wpdocker.dev

# Select password for the database connection
export WORDPRESS_DB_PASSWORD=example

# Fill these only if you want to retrieve SSL certificate
export LETSENCRYPT_HOST=
export LETSENCRYPT_EMAIL=

# Hostname of the containers. This should be the FQDN of the application.
export HOSTNAME=wpdocker.dev

# ACF pro lisence key
export ACF_KEY=your-advanced-custom-fields-key

# Caching method for mounts (:cached/:delegated/:conststent/<empty>)
export MOUNT_CACHE=
```

The value of the `LETSENCRYPT_HOST` should be same as in `VIRTUAL_HOST`.

If you are working on development environment, make sure that you have updated your `/etc/hosts` file with the same value as you have in the `VIRTUAL_HOST` variable:

```
127.0.0.1   wpdocker.dev
```

### Start the project

Start the [nginx-le-proxy](https://github.com/bond-agency/nginx-le-proxy).

Now you can start the containers with the start script.

```bash
sh start.sh
```

You can follow the logs of the composed containers with
```
docker-compose logs -f
```

To rebuild the containers every time you can add `--build` flag to the `up`-command.

The `wordpress/wp-content` folder is mounted from host machine so this the place where to put your own code.

## Caching

The boilerplate has ability to use FastCGI cache and it is [enabled by default in production mode](https://github.com/bond-agency/docker-wpbp/blob/master/nginx/config/vhost.production.conf#L30).

The project has a small script to purge this cache. The script is ment to be used in example always you have deployed new code and you want the cache to be cleaned. This could be the example command after successful deployment:

```
bash start.sh .env.production && bash purge.sh
```

## Contributing

You can open an issue if you have found a bug or you have an enhancement suggestion.