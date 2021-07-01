# Kong Update Cognito

Lambda to update `preferred_username` (cpf) field on cognito.

## Requeriments

- Serverless - [Install Serverless](https://www.serverless.com/framework/docs/getting-started/)

You may need the following for local testing.

- Node.js - [Install Node.js 14](https://nodejs.org/), including the [Yarn](https://yarnpkg.com/getting-started/install) package management tool.

## Local Test

```bash
$ git clone https://github.com/madeiramadeirabr/kong-update-cognito
$ cd kong-update-cognito
$ yarn install
$ yarn run build
$ cd dist
$ serverless invoke local -f kong-update-cognito -p ../events/event.json
```

### You should receive the payload example below as response:

```bash
{
  "statusCode": 200,
  "body": {
    "message": ""
  }
}
```

Hint: use `$ git remote -v` to verify new remote.

## Unit tests

Tests are defined in the `tests` folder in this project. Use NPM to install the [Jest test framework](https://jestjs.io/) and run unit tests from your local machine.

```bash
$ sudo yarn install
$ yarn run test
```

## Resources

See the [Serverless User Guides](https://www.serverless.com/framework/docs/guides/) for an introduction to Serverless specification, the Serverless CLI, and serverless application concepts.
