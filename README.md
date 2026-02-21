inception/
├── Makefile                    ← ONE Makefile at root
├── docker-compose.yml
├── srcs/
│   ├── requirements/
│   │   ├── nginx/
│   │   │   ├── Dockerfile
│   │   │   └── conf/
│   │   │   │__ tools/
│   │   │        │── mariadb_init
│   │   ├── wordpress/
│   │   │   ├── Dockerfile
│   │   │   └── conf/
│   │   │   │__ tools/
│   │   │        │──wordpress _init
│   │   └── mariadb/
│   │       ├── Dockerfile
│   │       └── conf/
│   │           │ ── demo.42.fr.conf
│   │           │ ── nginx.conf
├── .env
├── README.md
├── USER_DOC.md
└── DEV_DOC.md


//////////// docker clining commands /////////////

docker_clining() {
    docker stop $(docker ps -aq) 2>/dev/null
    docker rm $(docker ps -aq) 2>/dev/null
    docker rmi -f $(docker images -aq) 2>/dev/null
    docker volume rm $(docker volume ls -q) 2>/dev/null
    docker network rm $(docker network ls -q | grep -v "bridge\|host\|none") 2>/dev/null
}