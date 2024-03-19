docker stop $(docker ps -a -q)
docker rmi  $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
docker system prune -f