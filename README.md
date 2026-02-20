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