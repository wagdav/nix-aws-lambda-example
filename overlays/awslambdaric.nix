# Based on the example https://nixos.wiki/wiki/Overlays#Python_Packages_Overlay
final: prev:
rec {
  python3 = prev.python3.override
    {
      packageOverrides = final: prev: {
        awslambdaric = prev.awslambdaric.overrideAttrs (old: {
          disabledTests = (old.disabledTests or [ ]) ++ [
            # Tests fail with "ValueError: Out of range float values are not JSON compliant"
            "test_to_json_decimal_encoding_nan"
            "test_to_json_decimal_encoding_negative_nan"
          ];
        });
      };
    };

  python3Packages = python3.pkgs;
}
