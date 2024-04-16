# AWS Lambda Container Image with Nix

**Note**: This is an experiment.  Follow the official instructions to build a container image for AWS Lambda [here][AWSWorkingLambdaContainerImages].

## Requirement

Install the [Nix package manager](https://nixos.org/download/) and enable [flake support](https://nixos.wiki/wiki/Flakes).

## Run the application using AWS Lambda Interface Emulator

In one terminal start the [AWS Lambda Interface Emulator][AWSLambdaRIE]:

```
nix run github:wagdav/nix-lambda-example#aws-lambda-rie
```

Then in from a different terminal invoke the function:

```
curl -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{}'
```

## Development

Start a development server which restarts when `lambda_function.py` or `flake.nix` changes:

```
nix run .#devserver
```

# Reference

* [AWS Lambda Interface emulator][AWSLambdaRIE]
* [AWS Lambda base images][AWSLambdaBase]

[AWSLambdaRIE]: https://github.com/aws/aws-lambda-runtime-interface-emulator/
[AWSLambdaBase]: https://github.com/aws/aws-lambda-base-images
[AWSWorkingLambdaContainerImages]: https://docs.aws.amazon.com/lambda/latest/dg/images-create.html
