dockerFiles() {
    # Docker
    command -v docker >/dev/null 2>&1 && {
        echo "=== docker ==="
        local DOCKER_RUNNING=0;
        (docker version && DOCKER_RUNNING=1) || (DOCKER_RUNNING=0;)
        if [ $DOCKER_RUNNING -ne 1 ]; then
            echo "======= ERROR: docker daemon not running; skipping docker cleanup ======="
        else
            echo " BEFORE DOCKER CLEANUP:"
            docker system df
            # remove all docker artifacts
            echo "  = removing all docker containers"
            docker ps -a -q | xargs -r docker rm — force

            echo "  = removing all docker images"
            docker image prune --all --force

            echo "  = removing all docker volumes"
            docker volume prune --all --force

            echo "  = removing all docker networks"
            docker network prune --force

            echo "  = removing all docker builder caches"
            docker builder prune --all --force

            docker system prune --force --volumes

            echo " AFTER DOCKER CLEANUP:"
            docker system df

        fi
    }

}
