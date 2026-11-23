FROM mcr.microsoft.com/devcontainers/base:debian-13

ENV DEBIAN_FRONTEND=noninteractive \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH" \
    TZ="Europe/Warsaw"

# install all necessary apt packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        curl \
        wget \
        python3-pip \
        python3-venv \
        git \
        openssh-client \
        sshpass \
        bash-completion \
        shellcheck \
        jq \
        nano \
        vim \
        unzip \
        iputils-ping \
        dnsutils && \
    rm -rf /var/lib/apt/lists/*

# add opentofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    chmod +x install-opentofu.sh && \
    ./install-opentofu.sh --install-method deb && \
    rm -f install-opentofu.sh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.terraform.d/plugin-cache && \
    tofu --version

# add 1password cli
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" > /etc/apt/sources.list.d/1password.list && \
    mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol > /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
    mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
    apt-get update && \
    apt-get install -y --no-install-recommends 1password-cli && \
    rm -rf /var/lib/apt/lists/* && \
    op --version

# install all necessary pip packages
RUN python3 -m venv ${VIRTUAL_ENV} && \
    pip install --no-cache-dir --upgrade \
        pip \
        argcomplete \
        pytz \
        packaging \
        jmespath \
        netaddr \
        pynetbox \
        'paramiko<3.0' \
        ansible-pylibssh \
        ansible-dev-tools \
        proxmoxer \
        docker \
        molecule-plugins[docker]

# autocompletion
RUN mkdir -p /etc/bash_completion.d && \
    # docker
    curl -fsSL https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o /etc/bash_completion.d/docker && \
    # ansible
    register-python-argcomplete ansible > /etc/bash_completion.d/ansible && \
    register-python-argcomplete ansible-config > /etc/bash_completion.d/ansible-config && \
    register-python-argcomplete ansible-console > /etc/bash_completion.d/ansible-console && \
    register-python-argcomplete ansible-doc > /etc/bash_completion.d/ansible-doc && \
    register-python-argcomplete ansible-galaxy > /etc/bash_completion.d/ansible-galaxy && \
    register-python-argcomplete ansible-inventory > /etc/bash_completion.d/ansible-inventory && \
    register-python-argcomplete ansible-playbook > /etc/bash_completion.d/ansible-playbook && \
    register-python-argcomplete ansible-pull > /etc/bash_completion.d/ansible-pull && \
    register-python-argcomplete ansible-vault > /etc/bash_completion.d/ansible-vault && \
    # molecule
    _MOLECULE_COMPLETE=bash_source molecule > /etc/bash_completion.d/molecule && \
    # opentofu
    # echo "complete -o nospace -C /usr/bin/tofu tofu" > /etc/bash_completion.d/tofu && \
    tofu -install-autocomplete && \
    # 1password
    op completion bash > /etc/bash_completion.d/1password

# .bashrc
RUN echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc && \
    echo "export PS1='\u@\h:\w\$ '" >> /root/.bashrc
