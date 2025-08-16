Get-Content backup.sql | docker exec -i n8n-docker-postgres-1 psql -U n8n -d n8n

docker exec -t <postgres-container> pg_dump -U n8n -d n8n > backup.sql