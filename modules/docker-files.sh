dockerFiles() {
    # Docker
    command -v docker >/dev/null 2>&1 && {
        echo "=== docker ==="
        local DOCKER_RUNNING=0;
        docker version && DOCKER_RUNNING=1 || DOCKER_RUNNING=0;
        if [ ! $DOCKER_RUNNING == 1 ]; then

            echo "        INFO: docker daemon not running; attempting to start docker desktop ..."
            command docker desktop start >/dev/null 2>&1 && {
                DOCKER_RUNNING=1
	    } || {
                echo "======= ERROR: docker daemon not running and couldn't start; skipping docker cleanup ======="
            }
	    fi

        if [ $DOCKER_RUNNING == 1 ]; then
            echo " BEFORE DOCKER CLEANUP:"
            docker system df
            # remove all docker artifacts
            echo "  = removing all docker containers"
            docker ps -a -q | xargs -r docker rm -—force

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
    } || {
	    echo "=== 'docker' command not found; continuing... ==="
    }

}
