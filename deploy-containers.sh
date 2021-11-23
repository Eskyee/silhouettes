cp server/.env.sample server/.env
docker-compose -f server/docker-compose.yml run --rm app yarn install
docker-compose -f server/docker-compose.yml up -d
docker-compose -f docker-compose.svelte.yml up -d
