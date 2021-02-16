# AWS Lambda Container Image with Nix

**Note**: This is an experiment.  You can find the official AWS Lambda Base
Containers Images [here][AWSLambdaBase].

## Requirements

Nix package manager with [flake support](https://nixos.wiki/wiki/Flakes).

## Run the development server

```
nix run github:wagdav/nix-lambda-example
```

Then in a separate terminal:

```
curl -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{}'
```

[AWSLambdaBase]: https://github.com/aws/aws-lambda-base-images
