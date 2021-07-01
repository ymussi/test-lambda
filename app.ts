import { ResponseService } from "./src/web-service/responseService";
import { CognitoWebService } from "./src/web-service/cognitoWebService";
import { ResponseBodyType } from "./src/interfaces/responseBodyType";
import { EventBodyType } from "./src/interfaces/eventBodyType";
import { Cognito } from "./config";
import AWS from "aws-sdk";
AWS.config.region = Cognito.REGION;

export const handler = async (
  event: EventBodyType
): Promise<ResponseBodyType> => {
  const responseService = new ResponseService();
  const cognitoWebService = new CognitoWebService();
  try {
    if (!event) {
      throw new Error("Bad Request");
    }
    await cognitoWebService.insertUserPreferredUsername(event.accessToken,event.preferred_username)

    return responseService.makeResponseSuccess("Updated successfully.");
  } catch (err) {
    console.log("aqui-------------------------->")
    return responseService.makeResponseError(err);
  }
};
