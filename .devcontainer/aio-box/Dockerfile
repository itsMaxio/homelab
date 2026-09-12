FROM mcr.microsoft.com/devcontainers/base:debian-12

ENV DEBIAN_FRONTEND=noninteractive \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH" \
    TZ="Europe/Warsaw"

# install all necessary apt packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg \
        software-properties-common \
        curl \
        wget \
        python3-pip \
        python3-venv \
        git \
        openssh-client \
        sshpass \
        bash-completion \
        jq \
        nano \
        vim \
        unzip \
        iputils-ping \
        dnsutils && \
    rm -rf /var/lib/apt/lists/*

# add terraform
# RUN wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
#     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#         terraform && \
#     rm -rf /var/lib/apt/lists/*

# add 1password cli
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
    sudo tee /etc/apt/sources.list.d/1password.list && \
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
    sudo apt-get update && sudo apt-get install -y --no-install-recommends 1password-cli && \
    rm -rf /var/lib/apt/lists/* && \
    op --version

# # add 1password cli beta
# RUN wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.39.1-beta.01/op_linux_amd64_v2.39.1-beta.01.zip" -O op.zip && \
#     unzip -d op op.zip && \
#     sudo mv op/op /usr/local/bin/ && \
#     rm -r op.zip op && \
#     sudo groupadd -f onepassword-cli && \
#     sudo chgrp onepassword-cli /usr/local/bin/op && \
#     sudo chmod g+s /usr/local/bin/op

# install all necessary pip packages
RUN python3 -m venv ${VIRTUAL_ENV} && \
    pip install --no-cache-dir --upgrade \
        pip \
        argcomplete \
        pytz \
        'paramiko<3.0' \
        ansible-pylibssh \
        ansible-dev-tools \
        docker \
        molecule-plugins[docker]

# autocompletition
RUN mkdir -p /etc/bash_completion.d && \
    # docker
    curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o /etc/bash_completion.d/docker && \
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
    # terraform
    # terraform -install-autocomplete && \
    # 1password
    op completion bash > /etc/bash_completion.d/1password

# .bashrc
RUN echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc && \
    echo "cd /workspace" >> /root/.bashrc && \
    echo "export PS1='\u@\h:\w\$ '" >> /root/.bashrc