# Silhouettes Movie

## Local Development

Run the frontend dev server:

    yarn dev

Run the backend containers:

    cd server
    cp .env.sample .env
    docker-compose up -d

## Deployment

1. SSH into the server instance where you wish to deploy this app
2. Clone the repo
3. Make sure the domain or sub-domain you wish to serve this app on is pointed to the public ip of the server
4. Set the `VIRTUAL_HOST` and `LETSENCRYPT_HOST` environment variables in the `docker-compose.svelte.yml` file
5. Run ./deploy-containers.sh and wait for everything to build

### Logs

- Frontend (Svelte) app: `docker-compose -f docker-compose.svelte.yml logs -f --tail=200`
- Backend: `docker-compose -f server/docker-compose.yml logs -f --tail=200`

Both these commands will stream logs starting from 200 lines of most recent logs
