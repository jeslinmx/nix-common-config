_: {config, ...}: {
  services.gitea.settings.server.SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
  services.openssh.authorizedKeysFiles = ["${config.services.gitea.stateDir}/.ssh/authorized_keys"];
}
