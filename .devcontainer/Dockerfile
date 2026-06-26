FROM debian:13-slim@sha256:4e401d95de7083948053197a9c3913343cd06b706bf15eb6a0c3ccd26f436a0e AS fetch-base

USER root:root

WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget unzip tar xz-utils curl jq && \
    rm -rf /var/lib/apt/lists/*

FROM fetch-base AS ninja

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG NINJA_VERSION=v1.13.2

RUN NINJA_FILE="ninja-linux.zip" && \
    NINJA_API_RESPONSE=$(curl -fsSL --retry 3 --retry-connrefused --connect-timeout 15 --max-time 120 "https://api.github.com/repos/ninja-build/ninja/releases/tags/${NINJA_VERSION}") && \
    NINJA_DIGEST=$(echo "${NINJA_API_RESPONSE}" | jq -r ".assets[] | select(.name == \"${NINJA_FILE}\") | .digest") && \
    if [ -z "${NINJA_DIGEST}" ] || [ "${NINJA_DIGEST}" = "null" ]; then \
        echo "ERROR: Failed to get Ninja digest from GitHub API"; \
        echo "API Response: ${NINJA_API_RESPONSE}"; \
        exit 1; \
    fi && \
    if [[ ! "${NINJA_DIGEST}" =~ ^sha256: ]]; then \
        echo "ERROR: Unexpected Ninja digest format: ${NINJA_DIGEST}"; \
        echo "Expected format: sha256:HASH"; \
        exit 1; \
    fi && \
    NINJA_HASH=$(echo "${NINJA_DIGEST}" | cut -d: -f2) && \
    wget -q --tries=3 --timeout=30 --retry-connrefused "https://github.com/ninja-build/ninja/releases/download/${NINJA_VERSION}/${NINJA_FILE}" && \
    echo "${NINJA_HASH}  ${NINJA_FILE}" | sha256sum --check && \
    unzip -q "${NINJA_FILE}" -d /usr/local/bin && \
    rm "${NINJA_FILE}"

FROM fetch-base AS cmake

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG CMAKE_VERSION=v4.3.3

RUN CMAKE_VERSION_NUM="${CMAKE_VERSION#v}" && \
    CMAKE_FILE="cmake-${CMAKE_VERSION_NUM}-linux-x86_64.tar.gz" && \
    CMAKE_API_RESPONSE=$(curl -fsSL --retry 3 --retry-connrefused --connect-timeout 15 --max-time 120 "https://api.github.com/repos/Kitware/CMake/releases/tags/${CMAKE_VERSION}") && \
    CMAKE_DIGEST=$(echo "${CMAKE_API_RESPONSE}" | jq -r ".assets[] | select(.name == \"${CMAKE_FILE}\") | .digest") && \
    if [ -z "${CMAKE_DIGEST}" ] || [ "${CMAKE_DIGEST}" = "null" ]; then \
        echo "ERROR: Failed to get CMake digest from GitHub API"; \
        echo "API Response: ${CMAKE_API_RESPONSE}"; \
        exit 1; \
    fi && \
    if [[ ! "${CMAKE_DIGEST}" =~ ^sha256: ]]; then \
        echo "ERROR: Unexpected CMake digest format: ${CMAKE_DIGEST}"; \
        echo "Expected format: sha256:HASH"; \
        exit 1; \
    fi && \
    CMAKE_HASH=$(echo "${CMAKE_DIGEST}" | cut -d: -f2) && \
    wget -q --tries=3 --timeout=30 --retry-connrefused "https://github.com/Kitware/CMake/releases/download/${CMAKE_VERSION}/${CMAKE_FILE}" && \
    echo "${CMAKE_HASH}  ${CMAKE_FILE}" | sha256sum --check && \
    mkdir -p /opt/cmake && \
    tar -xzf "${CMAKE_FILE}" -C /opt/cmake --strip-components=1 && \
    rm "${CMAKE_FILE}"

FROM fetch-base AS arm-none-eabi

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ARM_NONE_EABI_VERSION=15.2.rel1

RUN ARM_NONE_EABI_FILE="arm-gnu-toolchain-${ARM_NONE_EABI_VERSION}-x86_64-arm-none-eabi.tar.xz" && \
    ARM_NONE_EABI_HASH_FILE="${ARM_NONE_EABI_FILE}.sha256asc" && \
    wget -q --tries=3 --timeout=30 --retry-connrefused "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_NONE_EABI_VERSION}/binrel/${ARM_NONE_EABI_FILE}" && \
    wget -q --tries=3 --timeout=30 --retry-connrefused "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_NONE_EABI_VERSION}/binrel/${ARM_NONE_EABI_HASH_FILE}" && \
    sha256sum --check "${ARM_NONE_EABI_HASH_FILE}" && \
    mkdir -p /opt/arm-none-eabi-gcc && \
    tar -xf "${ARM_NONE_EABI_FILE}" -C /opt/arm-none-eabi-gcc --strip-components=1 && \
    rm "${ARM_NONE_EABI_FILE}" "${ARM_NONE_EABI_HASH_FILE}"

FROM fetch-base AS task

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TASK_VERSION=v3.51.1

RUN TASK_FILE="task_linux_amd64.tar.gz" && \
    TASK_API_RESPONSE=$(curl -fsSL --retry 3 --retry-connrefused --connect-timeout 15 --max-time 120 "https://api.github.com/repos/go-task/task/releases/tags/${TASK_VERSION}") && \
    TASK_DIGEST=$(echo "${TASK_API_RESPONSE}" | jq -r ".assets[] | select(.name == \"${TASK_FILE}\") | .digest") && \
    if [ -z "${TASK_DIGEST}" ] || [ "${TASK_DIGEST}" = "null" ]; then \
        echo "ERROR: Failed to get Task digest from GitHub API"; \
        echo "API Response: ${TASK_API_RESPONSE}"; \
        exit 1; \
    fi && \
    if [[ ! "${TASK_DIGEST}" =~ ^sha256: ]]; then \
        echo "ERROR: Unexpected Task digest format: ${TASK_DIGEST}"; \
        echo "Expected format: sha256:HASH"; \
        exit 1; \
    fi && \
    TASK_HASH=$(echo "${TASK_DIGEST}" | cut -d: -f2) && \
    wget -q --tries=3 --timeout=30 --retry-connrefused "https://github.com/go-task/task/releases/download/${TASK_VERSION}/${TASK_FILE}" && \
    echo "${TASK_HASH}  ${TASK_FILE}" | sha256sum --check && \
    tar -xzf "${TASK_FILE}" -C /usr/local/bin task && \
    rm "${TASK_FILE}" && \
    chmod +x /usr/local/bin/task

FROM debian:13-slim@sha256:4e401d95de7083948053197a9c3913343cd06b706bf15eb6a0c3ccd26f436a0e

LABEL org.opencontainers.image.title="The Embedded Society's ARM Cortex-M Libraries Development Environment" \
    org.opencontainers.image.description="Development environment for building and testing the Embedded Society's ARM Cortex-M libraries" \
    org.opencontainers.image.authors="The Embedded Society" \
    org.opencontainers.image.source="https://github.com/embedded-society/arm-cortex-mx-core-tests" \
    org.opencontainers.image.vendor="https://github.com/embedded-society" \
    org.opencontainers.image.licenses="GPL-3.0"

USER root:root

WORKDIR /root

ENV PATH="/opt/arm-none-eabi-gcc/bin:/opt/cmake/bin:${PATH}"

COPY --from=ninja /usr/local/bin/ninja /usr/local/bin/
COPY --from=task /usr/local/bin/task /usr/local/bin/
COPY --from=cmake /opt/cmake/ /opt/cmake/
COPY --from=arm-none-eabi /opt/arm-none-eabi-gcc/ /opt/arm-none-eabi-gcc/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG LLVM_VERSION=19

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates git "llvm-${LLVM_VERSION}-tools" && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s "/usr/bin/FileCheck-${LLVM_VERSION}" /usr/bin/FileCheck && \
    ln -s "/usr/bin/FileCheck-${LLVM_VERSION}" /usr/bin/filecheck && \
    ninja --version && \
    cmake --version && \
    arm-none-eabi-gcc --version && \
    git --version && \
    filecheck --version && \
    FileCheck --version && \
    task --version

CMD ["/bin/bash"]
