import { StatusCode } from "../../config";
import { ResponseBodyType } from "../interfaces/responseBodyType";

export class ResponseService {
  makeResponseSuccess(responseMessage: string): ResponseBodyType {
    return {
      statusCode: StatusCode.OK,
      body: {
        message: responseMessage,
      },
    };
  }

  makeResponseError(responseError: string): ResponseBodyType {
    return {
      statusCode: StatusCode.BAD_REQUEST,
      body: {
        error: responseError,
      },
    };
  }
}
