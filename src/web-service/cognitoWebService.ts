import { Cognito } from "../../config";
import { CognitoIdentityServiceProvider, Config} from "aws-sdk";
import { UpdateUserAttributesRequest } from "aws-sdk/clients/cognitoidentityserviceprovider";
import AWS from "aws-sdk";
AWS.config.region = Cognito.REGION;
// let { region } =  new Config()
// region = Cognito.REGION;

export class CognitoWebService {
  async insertUserPreferredUsername(accessToken: string, preferred_username: string):Promise<void> {
    const cognitoidentityserviceprovider =
      new CognitoIdentityServiceProvider({
        apiVersion: "2016-04-18",
      });

    const payload: UpdateUserAttributesRequest = {
       AccessToken: accessToken,
       UserAttributes: [
        {
          Name: Cognito.PREFERRED_USERNAME,
          Value: preferred_username,
        },
      ]
    }
    
    console.log(`payload =====> ${JSON.stringify(payload, null, 2)}`);
    
    await cognitoidentityserviceprovider.updateUserAttributes(payload).promise()

  }
}
