{ extraConfig, ... }:
{
  testConfig =
    { pkgs, ... }:
    {
      virtualisation.quadlet = {
        containers.nginx = {
          containerConfig.image = "docker-archive:${pkgs.dockerTools.examples.nginx}";
          containerConfig.publishPorts = [ "8080:80" ];
          serviceConfig.TimeoutStartSec = "60";
        }
        // extraConfig;
      };
    };
  testScript = ''
    machine.wait_for_unit("nginx.service", user=systemd_user, timeout=30)

    html = machine.wait_until_succeeds("curl http://127.0.0.1:8080", timeout=5)
    assert "nginx" in html.lower()
  '';
}
