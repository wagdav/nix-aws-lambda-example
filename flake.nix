{
  description = "Example AWS Lambda Container Image";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      pythonEnv = pkgs.python38.withPackages (ps: [ ps.awslambdaric ]);

      hello-world-app = pkgs.runCommand "buildApp" { src = ./app.py; } ''
        mkdir -p $out
        cp $src $out/app.py
      '';

      devserver = pkgs.writeShellScript "devserver.sh" ''
        cd ${hello-world-app} && \
          ${pkgs.aws-lambda-rie}/bin/aws-lambda-rie \
          ${pythonEnv}/bin/python -m awslambdaric app.handler
      '';
    in
    {

      defaultPackage.${system} = self.packages.${system}.lambdaImage;

      apps.${system} = {
        devserver = {
          type = "app";
          program = "${devserver}";
        };
      };

      packages.${system} =
        {
          lambdaImage = pkgs.dockerTools.buildLayeredImage
            {
              name = "aws-lambda-with-nix";
              config = {
                EntryPoint = [
                  "${pkgs.aws-lambda-rie}/bin/aws-lambda-rie"
                  "${pythonEnv}/bin/python"
                  "-m"
                  "awslambdaric"
                ];

                WorkingDir = "${hello-world-app}";

                Cmd = [ "app.handler" ];
              };
            };
        };
    };
}
