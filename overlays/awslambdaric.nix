# https://nixos.org/manual/nixpkgs/stable/#how-to-override-a-python-package-for-all-python-versions-using-extensions
final: prev:
{
  pythonPackageExtensions = prev.pythonPackageExtensions ++ [
    (
      python-final: python-prev: {
        awslambdaric = python-prev.awslambdaric.overridePythonAttrs (old: {
          disabledTests = (old.disabledTests or [ ]) ++ [
            # Tests fail with "ValueError: Out of range float values are not JSON compliant"
            "test_to_json_decimal_encoding_nan"
            "test_to_json_decimal_encoding_negative_nan"
          ];
        });
      }
    )
  ];
}
