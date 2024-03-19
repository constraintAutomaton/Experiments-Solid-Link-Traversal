docker stop -f $(docker ps -a -q) || true
docker rmi -f $(docker ps -a -q) || true
docker system prune -f || true