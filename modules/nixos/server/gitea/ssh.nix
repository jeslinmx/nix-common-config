_: {config, ...}: {
  services.gitea.settings.server.SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
  openssh.authorizedKeysFiles = ["${config.services.gitea.stateDir}/.ssh/authorized_keys"];
}
