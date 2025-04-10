FROM jetpackio/devbox:latest

# Installing your devbox project
WORKDIR /code
USER root:root
RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} zig-master/ zig-master/
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} dotfiles/ /home/${DEVBOX_USER}/

RUN echo 'export ZIG_GLOBAL_CACHE_DIR=/tmp/zig-cache-global' >> ~/.profile && \
    echo 'export ZIG_LOCAL_CACHE_DIR=/tmp/zig-cache-local' >> ~/.profile

RUN devbox run -- echo "Installed Packages."

RUN devbox shellenv --init-hook >> ~/.profile
