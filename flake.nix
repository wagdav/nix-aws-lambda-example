{
  description = "Example AWS Lambda Container Image";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs
        {
          inherit system;
          overlays = [ (import ./overlays/awslambdaric.nix) ];
        };

      pythonEnv = pkgs.python3.withPackages (ps: [ ps.awslambdaric ]);

      hello-world-app = pkgs.runCommand "buildApp" { src = ./app.py; } ''
        mkdir -p $out
        cp $src $out/app.py
      '';

      aws-lambda-rie = pkgs.writeShellScript "aws-lambda-rie" ''
        ${pkgs.aws-lambda-rie}/bin/aws-lambda-rie ${pythonEnv}/bin/python -m awslambdaric app.handler
      '';

      devserver = pkgs.writeShellScript "devserver" ''
        ls *.py flake.nix | ${pkgs.entr}/bin/entr -r ${aws-lambda-rie}
      '';
    in
    {

      defaultPackage.${system} = self.packages.${system}.lambdaImage;

      apps.${system} = {
        aws-lambda-rie = {
          type = "app";
          program = "${aws-lambda-rie}";
        };

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
