{...}: _: {
  services.getty.greetingLine = ''
    \e{reset}Welcome to \e{red}\n \e{magenta}(\S{PRETTY_NAME})\e{reset} - \e{yellow}\l
    \e{reset}IPv4: \e{cyan}\4\e{reset}   IPv6: \e{cyan}\6\e{reset}
  '';
}
