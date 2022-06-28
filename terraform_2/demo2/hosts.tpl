[lbs]
%{ for i in range(length(names)) ~}
%{ if names[i] ==  "lb" ~}
${names[i]} ansible_host=${addrs[i]} ansible_user=${user}
%{ endif ~}
%{ endfor ~}

[apps]
%{ for i in range(length(names)) ~}
%{ if split("-", names[i])[0] ==  "app" ~}
${names[i]} ansible_host=${addrs[i]} ansible_user=${user}
%{ endif ~}
%{ endfor ~}
